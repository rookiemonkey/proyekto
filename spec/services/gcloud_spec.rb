require 'rails_helper'

RSpec.describe Gcloud do
  let(:uploaded_image) { described_class.upload(Rails.root.join('spec/support/im_a_test.png'), 'im_a_test.png') }

  describe 'bucket method' do
    it 'has bucket method' do
      expect(described_class.respond_to?(:bucket)).to eq(true)
    end

    it 'returns an instance of bucket' do
      expect(described_class.bucket.class).to eq(Google::Cloud::Storage::Bucket)
    end
  end

  describe 'get method' do
    it 'has get method' do
      expect(described_class.respond_to?(:get)).to eq(true)
    end

    it 'returns an instance of file' do
      expect(described_class.get(uploaded_image[:image_name]).class).to eq(Google::Cloud::Storage::File)
    end

    it 'returns nil if not existing' do
      expect(described_class.get('i_dont_exists.png')).to eq(nil)
    end

    it 'returns nil if emtpy argument' do
      expect(described_class.get(nil)).to eq(nil)
    end
  end

  describe 'upload method' do
    it 'has upload method' do
      expect(described_class.respond_to?(:upload)).to eq(true)
    end

    it 'returns a hash with image_url' do
      expect(uploaded_image.keys.include?(:image_url)).to eq(true)
    end

    it 'returns a hash with image_name' do
      expect(uploaded_image.keys.include?(:image_name)).to eq(true)
    end
  end

  describe 'delete method' do
    it 'has delete method' do
      expect(described_class.respond_to?(:delete)).to eq(true)
    end

    it 'returns true if succesful' do
      expect(described_class.delete(uploaded_image[:image_name])).to eq(true)
    end

    it 'returns nil if not existing' do
      expect(described_class.delete('i_dont_exists.png')).to eq(nil)
    end

    it 'returns nil if emtpy argument' do
      expect(described_class.delete(nil)).to eq(nil)
    end
  end
end
