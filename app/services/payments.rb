class Payments
  def self.available_payment_methods
    {
      visa: {
        strategy: 'visa',
        image: '/images/icon_visa.png'
      },
      mastercard: {
        strategy: 'mastercard',
        image: '/images/icon_mastercard.png'
      }
    }
  end
end
