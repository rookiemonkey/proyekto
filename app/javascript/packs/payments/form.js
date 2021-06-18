import PaymentAdapter from './adapter';
import stateInterface from './form_components/state';
import PlanListItem from './form_components/planListItem';
import PaymentMethodListItem from './form_components/paymentMethodListItem';
import ConfirmPlanChange from './form_components/confirmPlanChange';

export default class MultiStepForm extends PaymentAdapter {
  static screen = document.querySelector('#plan-screen')
  static token = document.querySelector('meta[name="csrf-token"]').content
  static plans = JSON.parse(window.availablePlans);
  static paymentMethods = JSON.parse(window.availablePaymentMethods);
  static state = stateInterface;

  static initialize() {
    this.toChoosePlan()
  }

  static navigate(page, params = null) {
    this.screen.innerHTML = ``;
    this[page](params);
  }

  static reset() {
    this.navigate('toChoosePlan');
    this.state = { ...stateInterface };
    if (document.querySelector('#plan-footer').childElementCount > 1) document.querySelector('#plan-footer').lastElementChild.remove()
  }

  static toChoosePlan(){
    PlanListItem.renderBaseHTML();
    Object.keys(this.plans).forEach(planName => new PlanListItem(this.plans[planName]))
  }

  static toChoosePaymentMethod(){
    PaymentMethodListItem.renderBaseHTML();
    Object.keys(this.paymentMethods).forEach(paymentMethodName => new PaymentMethodListItem(this.paymentMethods[paymentMethodName]))
  }

  static toConfirmPlanChange(newPlan) {
    new ConfirmPlanChange(newPlan)
  }

  static async proceedOnPlanChange({ result, error }) {
    if (!result) {
      window.notification.showMessage(error, 'error')
      return window.loader.hide()
    }

    const raw = await fetch(`/plans`, {
      method: 'PUT',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        "X-CSRF-Token": this.token
      },
      body: JSON.stringify({ plan: { plan: this.state.chosen_plan.name } })
    })

    const { success, message } = await raw.json()

    if (!success) {
      window.notification.showMessage(message, 'error')
      return window.loader.hide()
    }
    
    window.notification.showMessage(message, 'success');
    setTimeout(() => { window.location.replace("/dashboard") }, 3000)
  }

  // method mounted to DOM element in arrow function to avoid losing the context of this

  static chosePlan = event => {
    const { price, name } = event.target.closest('li.plan-list-item').dataset
    this.state = {...this.state, chosen_plan: { name, price }}
    if (name == 'free') return this.navigate('toConfirmPlanChange', name)
    this.navigate('toChoosePaymentMethod')
  }

  static chosePaymentMethod = event => {
    const { strategy } = event.target.closest('li.payment-method-list-item').dataset
    this.state = { ...this.state, chosen_payment_method: strategy }
    this.navigate(strategy)
  }
}