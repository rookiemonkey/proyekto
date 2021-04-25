class Artifact < ApplicationRecord
  belongs_to :project

  validates :name, presence: true
  validates :description, presence: true
end
