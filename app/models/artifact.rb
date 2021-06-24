class Artifact < ApplicationRecord
  after_destroy { CloudinaryWrapper.delete(self.image_name) }

  acts_as_tenant(:organization)
  belongs_to :project

  validates :name, presence: true
  validates :description, presence: true
end
