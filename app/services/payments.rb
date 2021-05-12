class Payments
  def self.available_payment_methods
    {
      paymongo: {
        strategy: 'paymongo',
        image: 'https://assets-global.website-files.com/60411749e60be86afb89d2f0/6041194a54fc8f4dfc8730bd_Paymongo_Final_Main_Logo_2020_RGB_green_horizontal.svg'
      }
    }
  end
end
