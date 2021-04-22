# https://developers.paymongo.com/docs/accepting-cards4
# paid plans amount is on pesos cents (eg: 150000 == 1,500)

class Plans
  def self.available_plans
    {
      free: 0,
      standard: 150_000,
      enterprise: 250_000
    }
  end
end
