# https://developers.paymongo.com/docs/accepting-cards4
# paid plans amount is on pesos cents (eg: 150000 == 1,500)

class Plans
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
end
