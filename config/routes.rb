Rails.application.routes.draw do
  post '/new/payment/intent', to: 'paymongo#create', as: 'new_payment_intent'
end
