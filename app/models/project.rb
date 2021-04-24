class Project < ApplicationRecord
  acts_as_tenant(:organization)
  validates :name, presence: true
end
