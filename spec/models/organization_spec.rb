require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:organization) { create(:organization) }

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

  context 'without subdomain' do
    before do
      organization.subdomain = nil
      organization.save
    end

    it 'will not save w/o subdomain' do
      expect(organization).not_to be_valid
    end

    it 'only have one error' do
      expect(organization.errors.full_messages.length).to eq(1)
    end

    it 'only have an error for subdomain' do
      expect(organization.errors.to_hash.keys).to include(:subdomain)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:projects) }
    it { is_expected.to have_many(:users) }
  end
end
