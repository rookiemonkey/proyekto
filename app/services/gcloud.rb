require 'google/cloud/storage'

class Gcloud
  @bucket = Google::Cloud::Storage.new(
    project_id: ENV['GLCOUD_PROJECT_ID'],
    credentials: File.expand_path('../../config/gcloud.json', File.dirname(__FILE__))
  ).bucket(ENV['GLCOUD_BUCKET_NAME'])

  class << self
    attr_reader :bucket
  end

  def self.upload(path, file_name)
    uploaded_file = Gcloud.bucket.create_file(File.open(path), file_name)
    { image_url: uploaded_file.public_url, image_name: file_name }
  end
end
