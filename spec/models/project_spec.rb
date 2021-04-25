require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create(:project) }

  context 'without name' do
    before do
      project.name = nil
      project.save
    end

    it 'will not save w/o name' do
      expect(project).not_to be_valid
    end

    it 'only have one error' do
      expect(project.errors.full_messages.length).to eq(1)
    end

    it 'only have an error for name' do
      expect(project.errors.to_hash.keys).to include(:name)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:artifacts) }
  end
end
