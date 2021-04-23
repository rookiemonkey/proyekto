require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context 'without full_name' do
    before do
      user.full_name = nil
      user.save
    end

    it 'will not save w/o full_name' do
      expect(user).not_to be_valid
    end

    it 'only have one error' do
      expect(user.errors.full_messages.length).to eq(1)
    end

    it 'only have an error for full_name' do
      expect(user.errors.to_hash.keys).to include(:full_name)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organization) }
  end
end
