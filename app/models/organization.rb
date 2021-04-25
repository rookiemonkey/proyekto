class Organization < ApplicationRecord
  before_save :set_subdomain

  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy

  validate :chosen_plan
  validates :name, presence: true

  def chosen_plan
    errors.add(:plan, 'is invalid') unless Plans.available_plans.key?(plan.downcase.to_sym)
  end

  private

  def set_subdomain
    self.subdomain = name.parameterize
  end
end
