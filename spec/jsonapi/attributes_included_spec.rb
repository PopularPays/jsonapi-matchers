require 'spec_helper'

describe Jsonapi::Matchers::AttributesIncluded do
  include Jsonapi::Matchers::Attributes

  let(:hash) do
    {
      data: {
        id: 'some-id',
        type: 'user',
        attributes: {
          name: 'cool-name',
          phone_number: '18001111111',
        }
      }
    }
  end

  describe 'have_attribute' do
    context 'attribute is included' do
      it 'matches' do
        expect(have_attribute(:name).matches?(hash)).to be_truthy
      end
    end

    context 'attribute is included' do
      subject { have_attribute(:address) }

      it 'does not match' do
        expect(subject.matches?(hash)).to be_falsey
      end

      it 'tells you that the target does not contain correct value' do
        subject.matches?(hash)
        expect(subject.failure_message).to match(/expected attribute 'address' to be included in/)
      end
    end

    describe 'with_value' do
      context 'value exists' do
        it 'matches' do
          expect(have_attribute(:name).with_value('cool-name').matches?(hash)).to be_truthy
        end
      end

      context 'value does not exist' do
        subject { have_attribute(:name).with_value('bad-name') }

        it 'does not match' do
          expect(subject.matches?(hash)).to be_falsey
        end

        it 'tells you the expected attribute does not exist' do
          subject.matches?(hash)
          expect(subject.failure_message).to eq("expected 'bad-name' for key 'name', but got 'cool-name'")
        end
      end

      context 'attribute does not exist' do
        subject { have_attribute(:address).with_value('bad-name') }

        it 'does not match' do
          expect(subject.matches?(hash)).to be_falsey
        end

        it 'tells you the expected attribute does not exist' do
          subject.matches?(hash)
          expect(subject.failure_message).to eq("expected 'bad-name' for key 'address', but got ''")
        end
      end
    end
  end

  describe 'have_id' do
    context 'id matches' do
      it 'matches' do
        expect(have_id('some-id').matches?(hash)).to be_truthy
      end
    end

    context 'id does not match' do
      subject { have_id('wrong-id') }

      it 'does not match' do
        expect(subject.matches?(hash)).to be_falsey
      end

      it 'tells you the expected attribute does not exist' do
        subject.matches?(hash)
        expect(subject.failure_message).to eq("expected 'wrong-id' for key 'id', but got 'some-id'")
      end
    end
  end

  describe 'have_type' do
    context 'type matches' do
      it 'matches' do
        expect(have_type('user').matches?(hash)).to be_truthy
      end
    end

    context 'type does not match' do
      subject { have_type('car') }

      it 'does not match' do
        expect(subject.matches?(hash)).to be_falsey
      end

      it 'tells you the expected attribute does not exist' do
        subject.matches?(hash)
        expect(subject.failure_message).to eq("expected 'car' for key 'type', but got 'user'")
      end
    end
  end
end
