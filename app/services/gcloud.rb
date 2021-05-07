require 'google/cloud/storage'

class Gcloud
  @bucket = Google::Cloud::Storage.new(
    project_id: ENV['GLCOUD_PROJECT_ID'],
    credentials: File.expand_path('../../config/gcloud.json', File.dirname(__FILE__))
  ).bucket(ENV['GLCOUD_BUCKET_NAME'])

  class << self
    attr_reader :bucket
  end

  def self.get(file_name)
    return nil unless file_name

    @bucket.file(file_name)
  end

  def self.upload(path, file_name)
    uploaded_file = Gcloud.bucket.create_file(File.open(path), file_name)
    authenticated_url = 'https://storage.cloud.google.com/proyekto-artifacts/'
    { image_url: "#{authenticated_url}#{uploaded_file.name}", image_name: file_name }
  end

  def self.delete(file_name)
    return nil unless file_name

    file = get(file_name)
    return nil unless file

    file.delete
  end
end
