require 'rails_helper'

RSpec.describe Gcloud do
  describe 'Class holds the storage Gcloud Storage instance' do
    it 'has storage method' do
      expect(described_class.respond_to?(:storage)).to eq(true)
    end

    it 'is an instance of Google::Cloud::Storage::Project' do
      expect(described_class.storage.class).to eq(Google::Cloud::Storage::Project)
    end
  end
end
