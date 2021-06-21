require 'rails_helper'

RSpec.describe Activity, type: :model do

  context 'base model w/o description' do
    let(:base_activity) { create(:activity) }

    before do
      base_activity.description = nil
      base_activity.save
    end

    it 'will not save w/o description' do
      expect(base_activity).not_to be_valid
    end

    it 'only have one error' do
      expect(base_activity.errors.full_messages.length).to eq(1)
    end

    it 'only have an error for description' do
      expect(base_activity.errors.to_hash.keys).to include(:description)
    end

    it 'has nil activity_type' do
      expect(base_activity.activity_type).to eq(nil)
    end
  end

  context '.create_staff_activity' do
    let(:staff_activity) { Activity.create_staff_activity(attributes_for(:activity)) }

    it 'has activity_type of "staff"'do
      expect(staff_activity.activity_type).to eq('staff')
    end
  end

  context '.create_account_activity' do
    let(:account_activity) { Activity.create_account_activity(attributes_for(:activity)) }

    it 'has activity_type of "account"'do
      expect(account_activity.activity_type).to eq('account')
    end
  end

  context '.create_artifact_activity' do
    let(:artifact_activity) { Activity.create_artifact_activity(attributes_for(:activity)) }

    it 'has activity_type of "artifact"'do
      expect(artifact_activity.activity_type).to eq('artifact')
    end
  end

  context '.create_project_activity' do
    let(:project_activity) { Activity.create_project_activity(attributes_for(:activity)) }

    it 'has activity_type of "project"'do
      expect(project_activity.activity_type).to eq('project')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organization) }
  end
end
