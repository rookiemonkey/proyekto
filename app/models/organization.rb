class Organization < ApplicationRecord
  before_save :set_subdomain
  before_update :set_related_models_based_on_new_plan

  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :artifacts, dependent: :destroy

  validate :chosen_plan
  validates :name, presence: true

  private

  def chosen_plan
    errors.add(:plan, 'is invalid') unless Plans.available_plans.key?(plan.downcase.to_sym)
  end

  def set_subdomain
    self.subdomain = name.parameterize
  end

  def set_related_models_based_on_new_plan
    Plans.change_plan(self)
  end
end
