import MultiStepForm from '../multi_step_form'

export default class PaymentMethodListItem {
  constructor(paymentMethod) {
    this.paymentMethod = paymentMethod
    this.parent = document.querySelector('.payment-method-list')
    const { strategy, image } = this.paymentMethod

    // render to the DOM
    this.parent.insertAdjacentHTML('beforeend', `
      <li class="payment-method-list-item" data-strategy="${strategy}">
        <img src=${image} data-strategy="${strategy}"/>
      </li>
    `)

    // mount event listener to the newly rendered list item
    this.parent.lastElementChild.addEventListener('click', MultiStepForm.chosePaymentMethod)
  }

  static renderBaseHTML() {
    MultiStepForm.screen.insertAdjacentHTML('beforeend', `
      <p>Choose from our payment methods below:</p> <br/>
      <ul class="payment-method-list"></ul>
    `)
  }
}