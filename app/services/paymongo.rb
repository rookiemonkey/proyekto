# https://developers.paymongo.com/docs/accepting-cards
# payment_method_id is default for 'card'

class Paymongo
  @base_url = 'https://api.paymongo.com/v1'.freeze
  @headers = { 'Content-Type': 'application/json', Authorization: "Basic #{Base64.encode64(ENV['PAYMONGO_SK'])}" }
  @plans = Plans.available_plans

  extend Paymongo::NewPaymentIntent
end
