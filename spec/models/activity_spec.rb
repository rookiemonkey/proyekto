require 'rails_helper'

RSpec.describe Activity, type: :model do
  context 'without description for base model' do
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

  describe '.create_staff_activity' do
    let(:staff_activity) { described_class.create_staff_activity(attributes_for(:activity)) }

    it 'has activity_type of "staff"' do
      expect(staff_activity.activity_type).to eq('staff')
    end
  end

  describe '.create_account_activity' do
    let(:account_activity) { described_class.create_account_activity(attributes_for(:activity)) }

    it 'has activity_type of "account"' do
      expect(account_activity.activity_type).to eq('account')
    end
  end

  describe '.create_artifact_activity' do
    let(:artifact_activity) { described_class.create_artifact_activity(attributes_for(:activity)) }

    it 'has activity_type of "artifact"' do
      expect(artifact_activity.activity_type).to eq('artifact')
    end
  end

  describe '.create_project_activity' do
    let(:project_activity) { described_class.create_project_activity(attributes_for(:activity)) }

    it 'has activity_type of "project"' do
      expect(project_activity.activity_type).to eq('project')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organization) }
  end
end
