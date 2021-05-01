require "google/cloud/storage"

class Gcloud
  @@storage = Google::Cloud::Storage.new(
    project_id: ENV['GLCOUD_PROJECT_ID'],
    credentials: "#{File.expand_path('../../config/gcloud.json', File.dirname(__FILE__))}",
  )

  def self.storage
    @@storage
  end
end