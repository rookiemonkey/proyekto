require 'rails_helper'

RSpec.describe Gcloud do
  let(:uploaded_image) { described_class.upload(Rails.root.join('spec/support/im_a_test.png'), 'im_a_test.png') }

  it 'has bucket method' do
    expect(described_class.respond_to?(:bucket)).to eq(true)
  end

  it 'has upload method' do
    expect(described_class.respond_to?(:upload)).to eq(true)
  end

  it 'bucket method returns instance of bucket' do
    expect(described_class.bucket.class).to eq(Google::Cloud::Storage::Bucket)
  end

  it 'upload method returns hash with image_url' do
    expect(uploaded_image.keys.include?(:image_url)).to eq(true)
  end

  it 'upload method returns hash with image_name' do
    expect(uploaded_image.keys.include?(:image_name)).to eq(true)
  end
end
