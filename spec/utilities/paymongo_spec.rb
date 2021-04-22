require 'rails_helper'

# https://developers.paymongo.com/docs/testing#basic-test-card-numbers

RSpec.describe Paymongo do
  describe 'Payment Intents (Invalid Plans)' do
    it 'raises runtime error for invalid plans' do
      expect { described_class.new_payment_intent(:not_a_plan) }.to raise_error(RuntimeError)
    end
  end

  describe 'Payment Intents (Paid Plans)' do
    let(:data) { described_class.new_payment_intent(:enterprise) }

    it 'returns a hash with 2 keys' do
      expect(data.keys.length).to eq(2)
    end

    it 'has CLIENT_KEY key' do
      expect(data.keys.include?(:CLIENT_KEY)).to eq(true)
    end

    it 'has PAYMENT_INTENT_ID key' do
      expect(data.keys.include?(:PAYMENT_INTENT_ID)).to eq(true)
    end
  end
end
