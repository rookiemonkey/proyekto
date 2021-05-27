import PaymentAdapter from './adapter';
import stateInterface from './form_components/state';
import PlanListItem from './form_components/planListItem';
import PaymentMethodListItem from './form_components/paymentMethodListItem';

export default class MultiStepForm extends PaymentAdapter {
  static screen = document.querySelector('#plan-screen')
  static plans = JSON.parse(window.availablePlans);
  static paymentMethods = JSON.parse(window.availablePaymentMethods);
  static state = stateInterface;

  static initialize() {
    this.toChoosePlan()
  }

  static navigate(page) {
    this.screen.innerHTML = ``;
    this[page]();
  }

  static toChoosePlan(){
    PlanListItem.renderBaseHTML();
    Object.keys(this.plans).forEach(planName => new PlanListItem(this.plans[planName]))
  }

  static toChoosePaymentMethod(){
    PaymentMethodListItem.renderBaseHTML();
    Object.keys(this.paymentMethods).forEach(paymentMethodName => new PaymentMethodListItem(this.paymentMethods[paymentMethodName]))
  }

  // method mounted to DOM element in arrow function to avoid losing the context of this

  static chosePlan = event => {
    const { price, name } = event.target.closest('li.plan-list-item').dataset
    this.state = {...this.state, chosen_plan: { name, price }}
    this.navigate('toChoosePaymentMethod')
  }

  static chosePaymentMethod = event => {
    const { strategy } = event.target.closest('li.payment-method-list-item').dataset
    this.state = { ...this.state, chosen_payment_method: strategy }
    this.navigate(strategy)
  }
}

MultiStepForm.initialize()