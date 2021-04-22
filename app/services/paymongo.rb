require 'json'
require 'base64'

# https://developers.paymongo.com/docs/accepting-cards4
# payment_method_id is default for 'card'

class Paymongo
  @base_url = 'https://api.paymongo.com/v1'.freeze
  @payment_intents_url = "#{@base_url}/payment_intents"
  @headers = { 'Content-Type': 'application/json', Authorization: "Basic #{Base64.encode64(ENV['PAYMONGO_SK'])}" }
  @plans = Plans.available_plans

  def self.new_payment_intent(plan)
    raise 'Invalid given plan' unless @plans.key?(plan)

    return { PAYMENT_INTENT_ID: 'free' } if plan == :free

    parameters = JSON.generate(
      {
        data: {
          attributes: {
            amount: @plans[plan],
            payment_method_allowed: ['card'],
            payment_method_options: {
              card: { request_three_d_secure: 'any' }
            },
            currency: 'PHP'
          }
        }
      }
    )

    raw_response = Faraday.post(@payment_intents_url, parameters, @headers)
    parsed_response = JSON.parse(raw_response.body)
    client_key = parsed_response['data']['attributes']['client_key']
    payment_intent_id = client_key.split('_client').first
    { CLIENT_KEY: client_key, PAYMENT_INTENT_ID: payment_intent_id }
  end
end
