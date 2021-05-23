require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:organization) { create(:organization, plan: 'free') }
  let(:enterprise_organization) { create(:organization, plan: 'enterprise') }

  before { create_list(:project, 10, organization: enterprise_organization) }

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

  context 'with before_update callback to set related model based on plan (downgrade to standard)' do
    let(:projects) { enterprise_organization.projects }

    before do # sample downgrade to standard
      enterprise_organization.plan = 'standard'
      enterprise_organization.save
      projects.reload
    end

    it 'has now 7 disabled projects' do
      expect(projects.where(disabled: true).length).to eq(7)
    end

    it 'has now 3 active projects' do
      expect(projects.where(disabled: false).length).to eq(3)
    end
  end

  context 'with before_update callback to set related model based on plan (downgrade to free)' do
    let(:projects) { enterprise_organization.projects }

    before do # sample downgrade to free
      enterprise_organization.plan = 'free'
      enterprise_organization.save
      projects.reload
    end

    it 'has now 9 disabled projects' do
      expect(projects.where(disabled: true).length).to eq(9)
    end

    it 'has now 1 active project' do
      expect(projects.where(disabled: false).length).to eq(1)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:projects) }
    it { is_expected.to have_many(:users) }
  end
end
