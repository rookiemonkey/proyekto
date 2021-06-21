require 'rails_helper'

RSpec.describe Plans::Free do
  let(:organization) { create(:user).organization }

  before { create_list(:project, 10, organization: organization) }

  describe 'from ENTERPRISE, activating FREE plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'free'
      organization.save
    end

    it 'disables 9 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(9)
    end

    it 'disables all the artifacts associated to all the disabled projects' do
      organization.projects.where(disabled: true).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(true)
      end
    end

    it 'leaves 1 project not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(1)
    end

    it 'leaves the last created project not disabled' do
      expect(organization.projects.find_by(disabled: false)).to eq(organization.projects.last)
    end

    it 'leaves the last created project\'s artifacts not disabled' do
      expect(organization.projects.last.artifacts.all?(&:disabled)).to eq(false)
    end
  end

  describe 'from STANDARD, activating FREE plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'standard'  # because factory generates enterprise org by default
      organization.save
      organization.plan = 'free'
      organization.save
    end

    it 'disables 9 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(9)
    end

    it 'disables all the artifacts associated to all the disabled projects' do
      organization.projects.where(disabled: true).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(true)
      end
    end

    it 'leaves 1 project not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(1)
    end

    it 'leaves the last created project not disabled' do
      expect(organization.projects.find_by(disabled: false)).to eq(organization.projects.last)
    end

    it 'leaves the last created project\'s artifacts not disabled' do
      expect(organization.projects.last.artifacts.all?(&:disabled)).to eq(false)
    end
  end

  describe 'from FREE, activating FREE plan' do
    before do
      organization.projects.each { |project| create_list(:artifact, 5, project: project, organization: organization) }
      organization.plan = 'free'
      organization.save
      organization.plan = 'free'
      organization.save
    end

    it 'disables 9 old projects' do
      expect(organization.projects.where(disabled: true).count).to eq(9)
    end

    it 'disables all the artifacts associated to all the disabled projects' do
      organization.projects.where(disabled: true).each do |project|
        expect(project.artifacts.all?(&:disabled)).to eq(true)
      end
    end

    it 'leaves 1 project not disabled' do
      expect(organization.projects.where(disabled: false).count).to eq(1)
    end

    it 'leaves the last created project not disabled' do
      expect(organization.projects.find_by(disabled: false)).to eq(organization.projects.last)
    end

    it 'leaves the last created project\'s artifacts not disabled' do
      expect(organization.projects.last.artifacts.all?(&:disabled)).to eq(false)
    end
  end
end
