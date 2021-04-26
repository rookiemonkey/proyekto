class Project < ApplicationRecord
  acts_as_tenant(:organization)
  has_many :artifacts, dependent: :destroy

  validate :organization_plan_restrictions
  validates :name, presence: true

  private

  def organization_plan_restrictions
    return unless organization

    restrict_by_plan if plan_is_free_and_reaches_project_limit
    restrict_by_plan if plan_is_standard_and_reaches_project_limit
  end

  def restrict_by_plan
    errors.add(:organization, 'plan restriction')
  end

  def plan_is_free_and_reaches_project_limit
    organization.plan == 'free' && organization.projects.count == Plans.available_plans[:free][:project_limit]
  end

  def plan_is_standard_and_reaches_project_limit
    organization.plan == 'standard' && organization.projects.count == Plans.available_plans[:standard][:project_limit]
  end
end
