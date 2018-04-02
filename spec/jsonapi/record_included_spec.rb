require 'spec_helper'

describe Jsonapi::Matchers::RecordIncluded do
  include Jsonapi::Matchers::Record

  let(:id) { }
  let(:record) { double(:record, {id: id}) }

  context 'expected is not a request object' do
    let(:subject) { have_record(record) }
    let(:response) { String.new }

    before do
      subject.matches?(response)
    end

    it 'tells you that the response is not an ActionDispatch::TestResponse' do
      expect(subject.failure_message).to eq("Expected response to be ActionDispatch::TestResponse, ActionController::TestResponse, or hash but was \"\"")
    end
  end

  context 'expected is not a json body' do
    let(:subject) { have_record(record) }
    let(:response) { ActionDispatch::TestResponse.new(response_data.to_json) }
    let(:response_data) { nil }

    before do
      subject.matches?(response)
    end

    it 'tells you that the response body is not json' do
      expect(subject.failure_message).to match("Expected response to be json string but was \"null\". JSON::ParserError - 776: unexpected token at 'null'")
    end
  end

  context 'checks :included' do
    let(:subject) { include_record(record) }
    let(:response) { ActionDispatch::TestResponse.new(response_data.to_json) }
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
    let(:response) { ActionDispatch::TestResponse.new(response_data.to_json) }

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

      context 'handles negated failure cases' do
        let(:id) { '3' }

        it 'does not blow up' do
          begin
            expect(response).to_not have_record(record)
          rescue NoMethodError => e
            fail("Should be able to handle negated cases without throwing an error: " + e.to_s)
          rescue RSpec::Expectations::ExpectationNotMetError
          end
        end

        it 'shows a negated error message' do
          @failure = nil
          begin
            expect(response).to_not have_record(record)
          rescue RSpec::Expectations::ExpectationNotMetError => e
            @failure = e.message
          end
          expect(@failure).to match(/expected object with an id of '3' to not be included in /)
        end
      end
    end
  end
end
