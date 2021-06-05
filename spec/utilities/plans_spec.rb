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

  describe 'changing an organization plan to another plan' do
    it 'returns true' do
      expect(described_class.change_plan(organization)).to eq(true)
    end
  end
end
