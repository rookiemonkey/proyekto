import PaymentAdapter from './payment_adapter';
import stateInterface from './multi_step_form/state';
import PlanListItem from './multi_step_form/planListItem';
import PaymentMethodListItem from './multi_step_form/paymentMethodListItem';

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

  // method mounted to dom in arrow function to avoid losing the context of this

  static chosePlan = event => {
    const { price, name } = event.target.dataset
    this.state = {...this.state, chosen_plan: { name, price }}
    this.navigate('toChoosePaymentMethod')
  }

  static chosePaymentMethod = event => {
    const { strategy } = event.target.dataset
    this.state = { ...this.state, chosen_payment_method: strategy }
    this.navigate(strategy)
  }
}

MultiStepForm.initialize()