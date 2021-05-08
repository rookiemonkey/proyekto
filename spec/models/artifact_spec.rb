require 'rails_helper'

RSpec.describe Artifact, type: :model do
  let(:artifact) { create(:artifact) }

  context 'without name' do
    before do
      artifact.name = nil
      artifact.save
    end

    it 'will not save w/o name' do
      expect(artifact).not_to be_valid
    end

    it 'only have one error' do
      expect(artifact.errors.full_messages.length).to eq(1)
    end

    it 'only have an error for name' do
      expect(artifact.errors.to_hash.keys).to include(:name)
    end
  end

  context 'without description' do
    before do
      artifact.description = nil
      artifact.save
    end

    it 'will not save w/o description' do
      expect(artifact).not_to be_valid
    end

    it 'only have one error' do
      expect(artifact.errors.full_messages.length).to eq(1)
    end

    it 'only have an error for description' do
      expect(artifact.errors.to_hash.keys).to include(:description)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:organization) }
  end
end
