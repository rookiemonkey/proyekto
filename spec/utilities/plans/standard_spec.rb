require 'rails_helper'

RSpec.describe 'Activating Standard Plan' do
  let(:organization) { create(:user).organization }

  before { create_list(:project, 10, organization: organization) }

  describe 'from STANDARD, activating STANDARD plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'standard'
      organization.save
      organization.plan = 'standard'
      organization.save
    end

    it 'disables 7 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(7)
    end

    it 'disables all the artifacts associated to all the disabled projects' do
      organization.projects.where(disabled: true).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(true)
      end
    end

    it 'leaves 3 project not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(3)
    end

    it 'leaves the last 3 created project not disabled' do
      expect(organization.projects.where(disabled: false)).to eq(organization.projects[-3..])
    end

    it 'leaves the last 3 created project\'s artifacts not disabled' do
      organization.projects[-3..].each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(false)
      end
    end
  end

  describe 'from FREE, activating STANDARD plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'free' # because factory generates enterprise org by default
      organization.save
      organization.plan = 'standard'
      organization.save
    end

    it 'disables 7 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(7)
    end

    it 'disables all the artifacts associated to all the disabled projects' do
      organization.projects.where(disabled: true).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(true)
      end
    end

    it 'leaves 3 project not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(3)
    end

    it 'leaves the last 3 created project not disabled' do
      expect(organization.projects.where(disabled: false)).to eq(organization.projects[-3..])
    end

    it 'leaves the last 3 created project\'s artifacts not disabled' do
      organization.projects[-3..].each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(false)
      end
    end
  end

  describe 'from ENTERPRISE, activating STANDARD plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'standard'
      organization.save
    end

    it 'disables 7 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(7)
    end

    it 'disables all the artifacts associated to all the disabled projects' do
      organization.projects.where(disabled: true).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(true)
      end
    end

    it 'leaves 3 project not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(3)
    end

    it 'leaves the last 3 created project not disabled' do
      expect(organization.projects.where(disabled: false)).to eq(organization.projects[-3..])
    end

    it 'leaves the last 3 created project\'s artifacts not disabled' do
      organization.projects[-3..].each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(false)
      end
    end
  end
end
