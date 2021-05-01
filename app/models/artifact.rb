class Artifact < ApplicationRecord
  belongs_to :project

  scope :of, lambda { |organization|
    artifacts = []
    Project.all.find_each do |project|
      project.artifacts.each { |artifact| artifacts << artifact } if project.organization == organization
    end
    artifacts
  }

  validates :name, presence: true
  validates :description, presence: true
end
