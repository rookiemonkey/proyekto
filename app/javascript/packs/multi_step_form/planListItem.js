import MultiStepForm from '../multi_step_form'
import parseAmount from '../utilities/parseAmount'

export default class PlanListItem {
  constructor(plan) {
    this.plan = plan
    this.parent = document.querySelector('.plan-list')
    const { name, price, project_details } = this.plan

    // project details into one string
    const project_details_string = project_details.reduce((string, details) => (
      string = string + `<span class="plan_details_item">${details}</span>`
    ), '')

    // render to the DOM
    this.parent.insertAdjacentHTML('beforeend', `
      <li class="plan-list-item" data-name="${name}" data-price="${price}">
        <div class="plan-list-item-image">
          <img src="/images/plan_${name}.png" />
        </div>
        <div class="plan-list-item-details">
          <p class="plan_name">${name.charAt(0).toUpperCase() + name.slice(1)}</p>
          <p class="plan_amount">${parseAmount(price * 0.01)}</p>
          <p class="plan_details">${project_details_string}</p>
        </div>
      </li>
    `)

    // if its the current plan, add active class
    if (name == window.currentPlan) this.parent.lastElementChild.classList.add('active')

    // mount event listener to the newly rendered list item
    this.parent.lastElementChild.addEventListener('click', MultiStepForm.chosePlan)
  }

  static renderBaseHTML() {
    MultiStepForm.screen.insertAdjacentHTML('beforeend', `
      <p>Choose from our plans below:</p> <br/>
      <ul class="plan-list"></ul>
    `)
  }
}