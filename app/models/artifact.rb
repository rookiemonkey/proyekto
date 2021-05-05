class Artifact < ApplicationRecord
  belongs_to :project

  validates :name, presence: true
  validates :description, presence: true
  after_destroy { Gcloud.delete(self.image_name) }

  scope :of, lambda { |organization|
    artifacts = []
    Project.all.find_each do |project|
      project.artifacts.each { |artifact| artifacts << artifact } if project.organization == organization
    end
    artifacts
  }
end
