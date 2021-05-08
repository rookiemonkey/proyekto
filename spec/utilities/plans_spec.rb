require 'rails_helper'

RSpec.describe Plans do
  let(:organization) { create(:user).organization }

  before { create_list(:project, 10, organization: organization) }

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

  describe 'changing an organization plan to the same plan' do
    it 'returns false' do
      expect(described_class.change_plan(organization, :enterprise)).to eq(false)
    end
  end

  describe 'changing an organization plan to another plan' do
    it 'returns true' do
      expect(described_class.change_plan(organization, :free)).to eq(true)
    end

    it 'changes the organization plan' do
      described_class.change_plan(organization, :free)
      expect(organization.plan).to eq('free')
    end
  end
end
