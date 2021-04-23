Rails.application.routes.draw do
  devise_for :users
  post '/new/payment/intent', to: 'paymongo#create', as: 'new_payment_intent'
end
