class Project < ApplicationRecord
  acts_as_tenant(:organization)
  has_many :artifacts, dependent: :destroy

  validate :organization_plan_restrictions
  validates :name, presence: true

  private

  def organization_plan_restrictions
    return unless organization

    errors.add(:organization, 'plan restriction') if organization_reaches_project_limit
  end

  def organization_reaches_project_limit
    plan = organization.plan.to_sym
    return false if plan == :enterprise

    organization.projects.count == Plans.available_plans[plan][:project_limit]
  end
end
