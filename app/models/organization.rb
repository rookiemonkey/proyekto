class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  validates :name, presence: true
  validates :subdomain, presence: true
end
