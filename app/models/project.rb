class Project < ApplicationRecord
  acts_as_tenant(:organization)
  has_many :artifacts, dependent: :destroy
  validates :name, presence: true
end
