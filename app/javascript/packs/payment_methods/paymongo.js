import MultiStepForm from '../multi_step_form'
import parseFormData from '../utilities/parseFormData'

export default class Paymongo {
  static publickKey = () => `${process.env.PAYMONGO_PK}`
  static cardInformationForm = () => document.getElementById('card_information_form')

  static initialize() {
    this.renderBaseHTML();
    this.cardInformationForm().addEventListener('submit', this.submitCardInformation)
  }

  static submitCardInformation = async event => {
    event.preventDefault()

    const formData = parseFormData(new FormData(this.cardInformationForm()))
    formData['exp_month'] = parseInt(formData['exp_month'])
    formData['exp_year'] = parseInt(formData['exp_year'])
    const body = { data: { attributes: { type: 'card', details: formData } } }

    const raw = await fetch('https://api.paymongo.com/v1/payment_methods', {
      method: 'POST',
      headers: {
        Accept: 'application/json', 
        'Content-Type': 'application/json', 
        Authorization: `Basic ${window.btoa(this.publickKey())}`
      },
      body: JSON.stringify(body)
    })

    const { data } = await raw.json()
    MultiStepForm.state = { ...MultiStepForm.state, strategy_state: { paymentMethodKey: data.id } }
  }

  static renderBaseHTML() {
    MultiStepForm.screen.insertAdjacentHTML('beforeend', `
      <form id="card_information_form">
        <div class="field is-horizontal"> 
          <div class="field-label is-normal">
            <label class="label">Card Number</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control">
                <input type="text" name="card_number" />
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
                <input type="number" name="exp_month" />
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
                <input type="number" name="exp_year" />
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
                <input type="text" name="cvc" />
              </div>
            </div>
          </div>
        </div>

        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <button type="submit">SUBMIT</button>
          </div>
        </div>
      </form>

      <div>
        <p>Powered by:</p>
        <img src="${MultiStepForm.paymentMethods[MultiStepForm.state.chosen_payment_method]['image']}" />
      </div>
    `)
  }
}