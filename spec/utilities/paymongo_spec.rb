require 'rails_helper'

# https://developers.paymongo.com/docs/testing#basic-test-card-numbers

RSpec.describe Paymongo do
  let(:card_details) do
    {
      card_number: 4_343_434_343_434_345,
      exp_month: Time.zone.today.month + 1,
      exp_year: Time.zone.today.year,
      cvc: 258
    }
  end

  let(:payment_method_id) { described_class.new_payment_method(card_details) }

  describe 'Payment Methods' do
    it 'return the payment method id' do
      expect(described_class.new_payment_method(card_details).class).to eq(String)
    end
  end

  describe 'Payment Intents (Invalid Plans)' do
    it 'raises runtime error for invalid plans' do
      expect { described_class.new_payment_intent({ plan: :not_a_plan, payment_method_id: payment_method_id }) }.to raise_error(RuntimeError)
    end
  end

  describe 'Payment Intents (Paid Plans)' do
    let(:data) { described_class.new_payment_intent({ plan: :enterprise, payment_method_id: payment_method_id }) }

    it 'returns a hash with 3 keys' do
      expect(data.keys.length).to eq(3)
    end

    it 'has PAYMENT_METHOD_ID key' do
      expect(data.keys.include?(:PAYMENT_METHOD_ID)).to eq(true)
    end

    it 'has CLIENT_KEY key' do
      expect(data.keys.include?(:CLIENT_KEY)).to eq(true)
    end

    it 'has PAYMENT_INTENT_ID key' do
      expect(data.keys.include?(:PAYMENT_INTENT_ID)).to eq(true)
    end
  end
end
