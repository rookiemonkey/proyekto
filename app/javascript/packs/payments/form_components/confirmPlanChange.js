import MultiStepForm from '../form'

export default class ConfirmPlanChange {
  constructor(newPlan) {
    this.newPlan = newPlan

    // render to DOM - Plan Screen
    MultiStepForm.screen
      .insertAdjacentHTML('beforeend', `
        <p>Please confirm to proceed in changing your plan from <strong>${window.currentPlan.charAt(0).toUpperCase() + window.currentPlan.slice(1)}</strong> to <strong>${this.newPlan.charAt(0).toUpperCase() + this.newPlan.slice(1)}</strong></p>
      `)

    // render to DOM - Plan Footer
    document.querySelector('#plan-footer')
      .insertAdjacentHTML('beforeend', `
        <button type='button' class="button is-primary" id="plan-confirm-button">
          Confirm
        </button>
      `)

    // mount event listener
    document.querySelector('#plan-confirm-button')
      .addEventListener('click', () => MultiStepForm.proceedOnPlanChange({ result: true, error: null }))
  }
}