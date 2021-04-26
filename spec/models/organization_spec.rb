require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:organization) { create(:organization, plan: 'free') }

  context 'with default subdomain value' do
    it 'uses parameterized version of the name' do
      expect(organization.subdomain).to eq(organization.name.parameterize)
    end
  end

  context 'with default plan value' do
    it 'is free' do
      expect(organization.plan).to eq('free')
    end
  end

  context 'without name' do
    before do
      organization.name = nil
      organization.save
    end

    it 'will not save w/o name' do
      expect(organization).not_to be_valid
    end

    it 'only have one error' do
      expect(organization.errors.full_messages.length).to eq(1)
    end

    it 'only have an error for name' do
      expect(organization.errors.to_hash.keys).to include(:name)
    end
  end

  context 'with invalid plan' do
    before do
      organization.plan = 'invalid plan here'
      organization.save
    end

    it 'will not save with invalid plan' do
      expect(organization).not_to be_valid
    end

    it 'only have one error' do
      expect(organization.errors.full_messages.length).to eq(1)
    end

    it 'only have an error for plan' do
      expect(organization.errors.to_hash.keys).to include(:plan)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:projects) }
    it { is_expected.to have_many(:users) }
  end
end
