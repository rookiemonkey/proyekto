class Organization < ApplicationRecord
  before_save :set_subdomain
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  validates :name, presence: true

  private

  def set_subdomain
    self.subdomain = name.parameterize
  end
end
