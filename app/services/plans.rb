# https://developers.paymongo.com/docs/accepting-cards4
# paid plans amount is on pesos cents (eg: 150000 == 1,500)

class Plans
  extend Plans::Free
  extend Plans::Standard
  extend Plans::Enterprise

  def self.send(method, *arguments)
    super(method, arguments)
    true
  end

  def self.available_plans
    {
      free: {
        price: 0,
        project_limit: 1
      },
      standard: {
        price: 150_000,
        project_limit: 3
      },
      enterprise: {
        price: 250_000,
        project_limit: 0
      }
    }
  end

  def self.change_plan(organization, new_plan)
    return false if organization.plan == new_plan.to_s

    self.send(new_plan, organization)
    organization.update(plan: new_plan)
  end
end
