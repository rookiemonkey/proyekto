require 'rails_helper'

RSpec.describe Plans do
  let(:organization) { create(:user).organization }

  before { create_list(:project, 10, organization: organization) }

  describe 'available plans' do
    let(:plans) { described_class.available_plans }

    it 'returns a hash' do
      expect(plans.class).to eq(Hash)
    end

    it 'has name key for each plans' do
      all_has_names = plans.keys.none? { |key| plans[key][:name].nil? }
      expect(all_has_names).to eq(true)
    end

    it 'has price key for each plans' do
      all_has_price = plans.keys.none? { |key| plans[key][:price].nil? }
      expect(all_has_price).to eq(true)
    end

    it 'has project_limit key for each plans' do
      all_has_project_limit = plans.keys.none? { |key| plans[key][:project_limit].nil? }
      expect(all_has_project_limit).to eq(true)
    end

    it 'has project_details key for each plans' do
      all_has_project_details = plans.keys.none? { |key| plans[key][:project_details].nil? }
      expect(all_has_project_details).to eq(true)
    end
  end

  describe 'activating FREE plan' do
    before { described_class.free(organization) }

    it 'disables 9 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(9)
    end

    it 'leaves 1 project not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(1)
    end

    it 'leaves the last created project not disabled' do
      expect(organization.projects.find_by(disabled: false)).to eq(organization.projects.last)
    end
  end

  describe 'activating STANDARD plan' do
    before { described_class.standard(organization) }

    it 'disables 7 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(7)
    end

    it 'leaves 3 project not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(3)
    end

    it 'leaves the last 3 created project not disabled' do
      expect(organization.projects.where(disabled: false)).to eq(organization.projects[-3..])
    end
  end

  describe 'activating ENTERPRISE plan' do
    before { described_class.enterprise(organization) }

    it 'disables 0 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(0)
    end

    it 'leaves all projects not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(10)
    end
  end

  describe 'changing an organization plan to another plan' do
    it 'returns true' do
      expect(described_class.change_plan(organization)).to eq(true)
    end
  end
end
