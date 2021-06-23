import MultiStepForm from '../payments/form'
import PaymentAdapter from '../payments/adapter'
import PlanPreview from '../payments/form_components/planPreview'
import HTMLElementLoader from '../components/loader'
import parseFormData from '../utilities/parseFormData'

export default class Paymongo {
  static authenticationKey = () => window.btoa(process.env.PAYMONGO_PK)
  static cardInformationForm = () => document.getElementById('paymongo_card_information_form')

  static initialize() {
    this.renderBaseHTML();
    this.cardInformationForm().addEventListener('submit', this.submitCardInformation)
  }

  static submitCardInformation = async event => {
    event.preventDefault()

    PlanPreview.hidePreview()
    window.loader = new HTMLElementLoader('#plan-screen').show();
    const formData = parseFormData(new FormData(this.cardInformationForm()))
    formData['exp_month'] = parseInt(formData['exp_month'])
    formData['exp_year'] = parseInt(formData['exp_year'])
    const body = { data: { attributes: { type: 'card', details: formData } } }

    const raw = await fetch('https://api.paymongo.com/v1/payment_methods', {
      method: 'POST',
      headers: {
        Accept: 'application/json', 
        'Content-Type': 'application/json', 
        Authorization: `Basic ${this.authenticationKey()}`
      },
      body: JSON.stringify(body)
    })

    const { data } = await raw.json()
    MultiStepForm.state = { ...MultiStepForm.state, strategy_state: { paymentMethodKey: data.id } }
    await this.submitPaymentIntent()
    await this.submitPayment()
  }

  static submitPaymentIntent = async () => {
    const raw = await fetch('/new/payment/intent', {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        "X-CSRF-Token": MultiStepForm.token
      },
      body: JSON.stringify({ plan: MultiStepForm.state.chosen_plan.name })
    })

    const { CLIENT_KEY, PAYMENT_INTENT_ID } = await raw.json()

    MultiStepForm.state = { 
      ...MultiStepForm.state, 
      strategy_state: { 
        ...MultiStepForm.state.strategy_state,
        clientKey: CLIENT_KEY, 
        paymentIntentId: PAYMENT_INTENT_ID 
      } 
    }
  }

  static submitPayment = async () => {
    const { paymentIntentId, clientKey, paymentMethodKey } = MultiStepForm.state.strategy_state
    const body = { data: { attributes: { client_key: clientKey, payment_method: paymentMethodKey } } }

    const raw = await fetch(`https://api.paymongo.com/v1/payment_intents/${paymentIntentId}/attach`, {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        Authorization: `Basic ${this.authenticationKey()}` 
      },
      body: JSON.stringify(body)
    })

    const response = await raw.json()
    const parsedResponse = PaymentAdapter.parsePaymongoResponse(response)
    await MultiStepForm.proceedOnPlanChange(parsedResponse)
  }

  static renderBaseHTML() {
    MultiStepForm.screen.insertAdjacentHTML('beforeend', `
      <form method="post" id="paymongo_card_information_form">
        <div class="field is-horizontal"> 
          <div class="field-label is-normal">
            <label class="label">Card Number</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control">
                <input type="text" class="input" name="card_number" />
              </div>
            </div>
          </div>
        </div>
 
        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label class="label">Expiration Month</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control">
                <input type="number" class="input" name="exp_month" />
              </div>
            </div>
          </div>
        </div>
        
        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label class="label">Expiration Year</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control">
                <input type="number" class="input" name="exp_year" />
              </div>
            </div>
          </div>
        </div>

        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label class="label">CVC</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control">
                <input type="text" class="input" name="cvc" />
              </div>
            </div>
          </div>
        </div>

        <div class="powered_by">
          <p>Powered by:
            <img src="https://assets-global.website-files.com/60411749e60be86afb89d2f0/6041194a54fc8f4dfc8730bd_Paymongo_Final_Main_Logo_2020_RGB_green_horizontal.svg" alt="paymongo" />
            <img src="/images/icon_${MultiStepForm.state.chosen_payment_method}.png" alt="${MultiStepForm.state.chosen_payment_method}" />
          </p>

          <button type="submit" class="button is-success">SUBMIT</button>
        </div>
      </form>
    `)
  }
}