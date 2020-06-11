require 'spec_helper'

describe Jsonapi::Matchers::AttributesIncluded do
  include Jsonapi::Matchers::Attributes

  it 'sets the description correctly' do
    expect(described_class.new('foo', 'bar', 'matcher description').description).to eq('matcher description')
  end

  shared_examples_for 'attributes included matcher' do
    describe 'have_attribute' do
      it 'has the correct description' do
        expect(have_attribute('some-attr').description).to eq("have attribute: some-attr")
      end

      context 'attribute is included' do
        it 'matches' do
          expect(have_attribute(:name).matches?(target)).to be_truthy
        end
      end

      context 'key exists but value is nil' do
        it 'matches' do
          expect(have_attribute(:email).matches?(target)).to be_truthy
        end
      end

      context 'attribute is not included' do
        subject { have_attribute(:address) }

        it 'does not match' do
          expect(subject.matches?(target)).to be_falsey
        end

        it 'tells you that the target does not contain correct value' do
          subject.matches?(target)
          expect(subject.failure_message).to match(/expected attribute 'address' to be included in/)
        end
      end

      context 'matcher is negated and attribute is included' do
        subject { have_attribute(:name) }

        it 'tells you that the target should not contain the correct value but does' do
          subject.matches?(target)
          expect(subject.failure_message_when_negated).to match(/expected attribute 'name' not to be included in/)
        end
      end

      describe 'with_value' do
        context 'value exists' do
          it 'matches' do
            expect(have_attribute(:name).with_value('cool-name').matches?(target)).to be_truthy
          end
        end

        context 'value does not exist' do
          subject { have_attribute(:name).with_value('bad-name') }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the expected attribute does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to eq("expected 'bad-name' for key 'name', but got 'cool-name'")
          end
        end

        context 'matcher is negated and value exists' do
          subject { have_attribute(:name).with_value('cool-name') }

          it 'tells you that the target should not contain the correct value but does' do
            subject.matches?(target)
            expect(subject.failure_message_when_negated).to match(/expected key 'name' to not be 'cool-name', but it was 'cool-name'/)
          end
        end

        context 'value is explicitly nil' do
          it 'matches' do
            expect(have_attribute(:email).with_value(nil).matches?(target)).to be_truthy
          end
        end

        context 'attribute does not exist' do
          subject { have_attribute(:address).with_value('bad-name') }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the expected attribute does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to eq("expected 'bad-name' for key 'address', but got ''")
          end
        end
      end
    end

    describe 'have_id' do
      it 'has the correct description' do
        expect(have_id('some-id').description).to eq("have id: some-id")
      end

      context 'id matches' do
        it 'matches' do
          expect(have_id('some-id').matches?(target)).to be_truthy
        end

        it 'has the expected negated failure message' do
          matcher = have_id('some-id')

          matcher.matches?(target)

          expect(matcher.failure_message_when_negated).to match(/expected key 'id' to not be 'some-id', but it was 'some-id'/)
        end
      end

      context 'id does not match' do
        subject { have_id('wrong-id') }

        it 'does not match' do
          expect(subject.matches?(target)).to be_falsey
        end

        it 'tells you the expected attribute does not exist' do
          subject.matches?(target)
          expect(subject.failure_message).to eq("expected 'wrong-id' for key 'id', but got 'some-id'")
        end
      end
    end

    describe 'have_type' do
      it 'has the correct description' do
        expect(have_type('some-type').description).to eq("have type: some-type")
      end

      context 'type matches' do
        it 'matches' do
          expect(have_type('user').matches?(target)).to be_truthy
        end

        it 'has the expected negated failure message' do
          matcher = have_type('user')

          matcher.matches?(target)

          expect(matcher.failure_message_when_negated).to match(/expected key 'type' to not be 'user', but it was 'user'/)
        end
      end

      context 'type does not match' do
        subject { have_type('car') }

        it 'does not match' do
          expect(subject.matches?(target)).to be_falsey
        end

        it 'tells you the expected attribute does not exist' do
          subject.matches?(target)
          expect(subject.failure_message).to eq("expected 'car' for key 'type', but got 'user'")
        end
      end
    end

    describe 'have_relationship' do
      it 'has the correct description' do
        expect(have_relationship('some-relationship').description).to eq("have relationship: some-relationship")
      end

      context 'relationship is included' do
        it 'matches' do
          expect(have_relationship(:car).matches?(target)).to be_truthy
        end

        it 'has the expected negated failure message' do
          matcher = have_relationship('some-relationship')

          matcher.matches?(target)

          expect(matcher.failure_message_when_negated).to match(/expected attribute 'some-relationship' not to be included in/)
        end
      end

      context 'key exists but value is nil' do
        it 'matches' do
          expect(have_relationship(:car).matches?(target)).to be_truthy
        end
      end

      context 'relationship is not included' do
        subject { have_relationship('monster_truck') }

        it 'does not match' do
          expect(subject.matches?(target)).to be_falsey
        end

        it 'tells you that the target does not contain correct value' do
          subject.matches?(target)
          expect(subject.failure_message).to match(/expected attribute 'monster_truck' to be included in/)
        end
      end

      describe 'with_value' do
        context 'value exists' do
          let(:relationship_value) do
            { 'data' => { 'type' => 'cars', 'id' => 'some-car-id' } }
          end

          it 'matches' do
            expect(have_relationship(:car).with_value(relationship_value).matches?(target)).to be_truthy
          end

          it 'has the expected negated failure message' do
            matcher = have_relationship(:car).with_value(relationship_value)

            matcher.matches?(target)

            expect(matcher.failure_message_when_negated).to match(/expected key 'car' to not be '.*', but it was '.*'/)
          end
        end

        context 'relationship exists but is nil' do
          let(:relationship_value) do
            { 'data' => nil }
          end

          it 'matches' do
            expect(have_relationship(:house).with_value(relationship_value).matches?(target)).to be_truthy
          end
        end

        context 'value does not exist' do
          subject { have_relationship(:car).with_value('ford') }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the expected relationship does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to eq("expected 'ford' for key 'car', but got '{\"data\"=>{\"type\"=>\"cars\", \"id\"=>\"some-car-id\"}}'")
          end
        end

        context 'value is explicitly nil' do
          it 'matches' do
            expect(have_relationship(:plane).with_value(nil).matches?(target)).to be_truthy
          end
        end

        context 'relationship does not exist' do
          subject { have_relationship(:address).with_value('bad-name') }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the expected relationship does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to eq("expected 'bad-name' for key 'address', but got ''")
          end
        end
      end

      describe 'with_record' do
        context 'record exists' do
          let(:record) { OpenStruct.new(id: 'some-car-id') }

          it 'matches' do
            expect(have_relationship(:car).with_record(record).matches?(target)).to be_truthy
          end

          context 'the record id is not a string' do
            let(:record) { OpenStruct.new(id: 3) }

            it 'matches' do
              expect(have_relationship(:bike).with_record(record).matches?(target)).to be_truthy
            end
          end
        end

        context 'record id does not match' do
          let(:record) { OpenStruct.new(id: 'not-the-right-car-id') }

          subject { have_relationship(:car).with_record(record) }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the expected id does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to eq("expected 'not-the-right-car-id' to be the id for relationship 'car', but got '{\"data\"=>{\"type\"=>\"cars\", \"id\"=>\"some-car-id\"}}'")
          end
        end

        context 'relationship is array and it matches' do
          let(:record) { OpenStruct.new(id: 'some-chair-id-1') }

          it 'matches' do
            expect(have_relationship(:chairs).with_record(record).matches?(target)).to be_truthy
          end

          context 'the record id is not a string' do
            let(:record) { OpenStruct.new(id: 4) }

            it 'matches' do
              expect(have_relationship(:telephones).with_record(record).matches?(target)).to be_truthy
            end
          end
        end

        context 'relationship is array and it does not match' do
          let(:record) { OpenStruct.new(id: 'some-chair-id-3') }

          subject { have_relationship(:chairs).with_record(record) }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the relationship does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to match("expected 'some-chair-id-3' to be an id in relationship 'chairs', but got")
          end
        end

        context 'relationship does not have an id attribute' do
          let(:record) { OpenStruct.new(id: 'some-chair-id-1') }

          subject { have_relationship(:house).with_record(record) }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the expected attribute does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to eq("expected 'some-chair-id-1' to be the id for relationship 'house', but got '{\"data\"=>nil}'")
          end
        end

        context 'relationship is nil' do
          let(:record) { OpenStruct.new(id: 'some-chair-id-1') }

          subject { have_relationship(:plane).with_record(record) }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the expected relationship does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to eq("expected 'some-chair-id-1' to be the id for relationship 'plane', but got ''")
          end
        end

        context 'relationship does not exist' do
          let(:record) { OpenStruct.new(id: 'some-chair-id-1') }

          subject { have_relationship(:does_not_exist).with_record(record) }

          it 'does not match' do
            expect(subject.matches?(target)).to be_falsey
          end

          it 'tells you the expected relationship does not exist' do
            subject.matches?(target)
            expect(subject.failure_message).to eq("expected 'some-chair-id-1' to be the id for relationship 'does_not_exist', but got ''")
          end
        end
      end
    end
  end

  let(:json_api_data) do
    {
      data: {
        id: 'some-id',
        type: 'user',
        attributes: {
          name: 'cool-name',
          phone_number: '18001111111',
          email: nil
        },
        relationships: {
          car: {
            data: { type: 'cars', id: 'some-car-id' }
          },
          bike: {
            data: { type: 'bikes', id: '3' }
          },
          house: {
            data: nil
          },
          plane: nil,
          chairs: {
            data: [
              { type: 'chairs', id: 'some-chair-id-1' },
              { type: 'chairs', id: 'some-chair-id-2' }
            ]
          },
          telephones: {
            data: [
              { type: 'telephone', id: '4' },
              { type: 'telephone', id: '5' }
            ]
          }
        }
      }
    }
  end

  context 'target is a hash with symbol keys' do
    let(:target) { json_api_data }

    it_should_behave_like 'attributes included matcher'
  end

  context 'target is a hash with string keys' do
    let(:target) { json_api_data.as_json }

    it_should_behave_like 'attributes included matcher'
  end

  context 'target is an action controller response' do
    let(:target) { ActionDispatch::TestResponse.new(json_api_data.to_json) }

    it_should_behave_like 'attributes included matcher'
  end
end
