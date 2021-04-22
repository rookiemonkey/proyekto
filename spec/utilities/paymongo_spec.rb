require 'rails_helper'

RSpec.describe Paymongo do
  describe 'Unsuccessful API Calls' do
    it 'raises runtime error for invalid plans' do
      expect { described_class.new_payment_intent_for(:not_a_plan) }.to raise_error(RuntimeError)
    end
  end

  describe 'Succesful API Calls (paid plans)' do
    let(:response) { described_class.new_payment_intent_for(:standard) }

    it 'returns a hash with 3 keys' do
      expect(response.keys.length).to eq(3)
    end

    it 'has PAYMENT_METHOD_ID key' do
      expect(response.keys.include?(:PAYMENT_METHOD_ID)).to eq(true)
    end

    it 'has CLIENT_KEY key' do
      expect(response.keys.include?(:CLIENT_KEY)).to eq(true)
    end

    it 'has PAYMENT_INTENT_ID key' do
      expect(response.keys.include?(:PAYMENT_INTENT_ID)).to eq(true)
    end
  end
end
