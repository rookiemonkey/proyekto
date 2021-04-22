require 'json'
require 'base64'

# https://developers.paymongo.com/docs/accepting-cards4
# payment_method_id is default for 'card'

class Paymongo
  @base_url = 'https://api.paymongo.com/v1'.freeze
  @payment_methods_url = "#{@base_url}/payment_methods"
  @payment_intents_url = "#{@base_url}/payment_intents"
  @headers = { 'Content-Type': 'application/json', Authorization: "Basic #{Base64.encode64(ENV['PAYMONGO_SK'])}" }
  @paid_plans = Plans.available_plans

  def self.new_payment_method(card_details)
    parameters = JSON.generate(
      {
        data: {
          attributes: {
            type: 'card',
            details: {
              card_number: card_details[:card_number].to_s,
              exp_month: card_details[:exp_month],
              exp_year: card_details[:exp_year],
              cvc: card_details[:cvc].to_s
            }
          }
        }
      }
    )

    raw_response = Faraday.post(@payment_methods_url, parameters, @headers)
    parsed_response = JSON.parse(raw_response.body)
    parsed_response['data']['id']
  end

  def self.new_payment_intent(intent_details)
    raise 'Invalid given plan' unless @paid_plans.key?(intent_details[:plan])

    return { PAYMENT_METHOD_ID: 'free' } if intent_details[:plan] == :free

    parameters = JSON.generate(
      {
        data: {
          attributes: {
            amount: @paid_plans[intent_details[:plan]],
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

    { PAYMENT_METHOD_ID: intent_details[:payment_method_id], CLIENT_KEY: client_key, PAYMENT_INTENT_ID: payment_intent_id }
  end
end
