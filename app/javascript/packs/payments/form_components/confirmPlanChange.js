import MultiStepForm from '../form'

export default class ConfirmPlanChange {
  constructor(newPlan) {
    this.newPlan = newPlan

    // render to DOM - Plan Screen
    MultiStepForm.screen
      .insertAdjacentHTML('beforeend', `
        <p>Please Confirm to to proceed in changing your plan from ${window.currentPlan} to ${this.newPlan}</p>
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