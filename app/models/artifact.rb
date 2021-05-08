class Artifact < ApplicationRecord
  acts_as_tenant(:organization)
  belongs_to :project

  validates :name, presence: true
  validates :description, presence: true
  after_destroy { Gcloud.delete(self.image_name) }
end
