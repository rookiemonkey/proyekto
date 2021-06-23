require 'rails_helper'

RSpec.describe Payments do
  describe 'Available Payment Methods' do
    let(:data) { described_class.available_payment_methods }

    it 'returns a hash' do
      expect(data.class).to eq(Hash)
    end

    it 'has strategy key for each payment method' do
      all_has_strategy = data.keys.none? { |key| data[key][:strategy].nil? }
      expect(all_has_strategy).to eq(true)
    end

    it 'has image key for each payment method' do
      all_has_image = data.keys.none? { |key| data[key][:image].nil? }
      expect(all_has_image).to eq(true)
    end

    it 'has visa' do
      expect(data.keys.include?(:visa)).to eq(true)
    end

    it 'has mastercard' do
      expect(data.keys.include?(:mastercard)).to eq(true)
    end
  end
end
