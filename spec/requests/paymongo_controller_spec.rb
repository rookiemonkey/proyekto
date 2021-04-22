require 'rails_helper'

RSpec.describe PaymongoController, type: :request do
  describe 'POST /new/payment/intent' do
    before { post new_payment_intent_path, params: { plan: 'standard' } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a hash with 2 keys' do
      expect(JSON.parse(response.body).keys.length).to eq(2)
    end

    it 'has CLIENT_KEY key' do
      expect(JSON.parse(response.body).keys.include?('CLIENT_KEY')).to eq(true)
    end

    it 'has PAYMENT_INTENT_ID key' do
      expect(JSON.parse(response.body).keys.include?('PAYMENT_INTENT_ID')).to eq(true)
    end
  end
end
