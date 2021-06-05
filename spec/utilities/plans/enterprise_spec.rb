require 'rails_helper'

RSpec.describe 'Activating Enterprise Plan' do
  let(:organization) { create(:user).organization }

  before { create_list(:project, 10, organization: organization) }

  describe 'from STANDARD, activating ENTERPRISE plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'standard' # because factory generates enterprise org by default
      organization.save
      organization.plan = 'enterprise'
      organization.save
    end

    it 'disables 0 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(0)
    end

    it 'leaves all projects not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(10)
    end

    it 'disables 0 artifacts associated to all the active projects' do
      organization.projects.where(disabled: false).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(false)
      end
    end
  end

  describe 'from FREE, activating ENTERPRISE plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'free' # because factory generates enterprise org by default
      organization.save
      organization.plan = 'enterprise'
      organization.save
    end

    it 'disables 0 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(0)
    end

    it 'leaves all projects not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(10)
    end

    it 'disables 0 artifacts associated to all the active projects' do
      organization.projects.where(disabled: false).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(false)
      end
    end
  end

  describe 'from ENTEPRISE, activating ENTERPRISE plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'enterprise'
      organization.save
    end

    it 'disables 0 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(0)
    end

    it 'leaves all projects not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(10)
    end

    it 'disables 0 artifacts associated to all the active projects' do
      organization.projects.where(disabled: false).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(false)
      end
    end
  end
end
