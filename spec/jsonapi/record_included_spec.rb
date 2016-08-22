require 'spec_helper'

describe 'record included' do
  include Jsonapi::Matchers::Response

  module ActionController
    class TestResponse
      attr_accessor :body

      def initialize(body)
        self.body = body
      end
    end
  end

  let(:id) { }
  let(:record) { double(:record, {id: id}) }

  context 'expected is not a request object' do
    let(:subject) { have_record(record) }
    let(:response) { {} }

    before do
      subject.matches?(response)
    end

    it 'tells you that the response is not an ActionController::TestResponse' do
      expect(subject.failure_message).to eq("Expected response to be ActionController::TestResponse with a body but was {}")
    end
  end

  context 'expected is not a json body' do
    let(:subject) { have_record(record) }
    let(:response) { ActionController::TestResponse.new(response_data.to_json) }
    let(:response_data) { nil }

    before do
      subject.matches?(response)
    end

    it 'tells you that the response body is not json' do
      expect(subject.failure_message).to eq("Expected response to be json string but was \"null\"")
    end
  end

  context 'checks :included' do
    let(:subject) { include_record(record) }
    let(:response) { ActionController::TestResponse.new(response_data.to_json) }
    let(:response_data) do
      {
        included: [{
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

      it 'says the id is not in the response' do
        subject.matches?(response)
        expect(subject.failure_message).to match(/expected object with an id of 'other_value' to be included in /)
      end
    end
  end

  context 'checks :data' do
    let(:subject) { have_record(record) }
    let(:response) { ActionController::TestResponse.new(response_data.to_json) }

    context 'data is an array' do
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

        it 'says the id is not in the response' do
          subject.matches?(response)
          expect(subject.failure_message).to match(/expected object with an id of 'other_value' to be included in /)
        end
      end
    end

    context 'data is an object' do
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
          subject.matches?(response)
          expect(subject.failure_message).to match(/expected object with an id of 'other_value' to be included in /)
        end
      end
    end
  end
end
