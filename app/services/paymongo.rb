# https://developers.paymongo.com/docs/accepting-cards4
# payment_method_id is default for 'card'
require 'json'
require 'base64'

class Paymongo
  @@base_url = 'https://api.paymongo.com/v1/payment_intents'.freeze
  @@payment_method_id = 'pm_ajeDG2y6WgnrCXaamWFmPUw2'.freeze
  @@paid_plans = Plans.available_plans

  def self.new_payment_intent_for(plan)
    raise 'Invalid given plan' unless @@paid_plans.key?(plan)

    return { PAYMENT_METHOD_ID: 'free' } if plan == :free

    parameters = JSON.generate(
      {
        data: {
          attributes: {
            amount: @@paid_plans[plan],
            payment_method_allowed: ['card'],
            payment_method_options: {
              card: { request_three_d_secure: 'any' }
            },
            currency: 'PHP'
          }
        }
      }
    )

    headers = {
      'Content-Type': 'application/json',
      Authorization: "Basic #{Base64.encode64(ENV['PAYMONGO_SK'])}"
    }

    raw_response = Faraday.post(@@base_url, parameters, headers)
    parsed_response = JSON.parse(raw_response.body)
    client_key = parsed_response['data']['attributes']['client_key']
    payment_intent_id = client_key.split('_client').first

    { PAYMENT_METHOD_ID: @@payment_method_id, CLIENT_KEY: client_key, PAYMENT_INTENT_ID: payment_intent_id }
  end
end
