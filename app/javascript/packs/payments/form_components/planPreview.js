import MultiStepForm from "../form"
import parseAmount from "../../utilities/parseAmount"

export default class PlanPreview {
  constructor(newPlanName) {
    const plan = MultiStepForm.plans[newPlanName]

    // project details into one string
    const project_details_string = plan.project_details.reduce((string, details) => (
      string = string + `<span class="plan_details_item">${details}</span>`
    ), '')

    // render to the DOM
    MultiStepForm.screen.insertAdjacentHTML('beforebegin', `
      <div class="plan-preview">
        <span class="plan-preview-message">Your chosen new plan for the organization:</span>
        <div class="plan-list-item">
          <div class="plan-list-item-image">
            <img src="/images/plan_${plan.name}.png">
          </div>
          <div class="plan-list-item-details">
            <p class="plan_name">${plan.name.charAt(0).toUpperCase() + plan.name.slice(1)}</p>
            <p class="plan_amount">${parseAmount(plan.price * 0.01)}</p>
            <p class="plan_details">${project_details_string}</p>
          </div>
        </div>
      </div>
    `)
  }

  static hidePreview = () => document.querySelector('.plan-preview').style.display = 'none'
  static showPreview = () => document.querySelector('.plan-preview').style.display = 'block'
}