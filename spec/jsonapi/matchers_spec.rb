require 'spec_helper'

describe Jsonapi::Matchers::Response do
  include Jsonapi::Matchers::Response

  module ActionController
    class TestResponse
      attr_accessor :body

      def initialize(body)
        self.body = body
      end
    end
  end

  context 'specing a request' do
    let(:id) { }
    let(:record) { double(:record, {id: id}) }
    let(:subject) { include(record) }

    context 'expected is not a request object' do
      let(:response) { {} }

      before do
        subject.matches?(response)
      end

      it 'tells you that the response is not an ActionController::TestResponse' do
        expect(subject.failure_message).to eq("Expect response to be ActionController::TestResponse with a body but was {}")
      end
    end

    context 'expected is a request object' do
      let(:response) { ActionController::TestResponse.new(response_data.to_json) }

      context 'expected is not a json body' do
        let(:response_data) { nil }

        before do
          subject.matches?(response)
        end

        it 'tells you that the response body is not json' do
          expect(subject.failure_message).to eq("Expect response to be json string but was \"null\"")
        end
      end

      context 'specifying inclusion location' do
        context 'data' do
          context 'array' do
            let(:response_data) do
              {
                data: [{
                  id: '3'
                }]
              }
            end

            context 'record is found' do
              let(:id) { '3' }

              it 'matches' do
                expect(subject.matches?(response)).to eq true
              end
            end

            context 'record is not found' do
              let(:id) { 'other_value' }

              it 'does not match' do
                expect(subject.matches?(response)).to eq false
              end
            end
          end

          context 'object' do
            let(:response_data) do
              {
                data: {
                  id: '3'
                }
              }
            end

            let(:record) { double(:record, {id: id}) }

            context 'record is found' do
              let(:id) { '3' }

              it 'matches' do
                expect(subject.matches?(response)).to eq true
              end
            end

            context 'record is not found' do
              let(:id) { 'other_value' }

              it 'does not match' do
                expect(subject.matches?(response)).to eq false
              end

              it 'says the id is not in the response' do
                expect(matcher.failure_message).not_to be_nil
              end
            end
          end
        end
      end
    end
  end
end
