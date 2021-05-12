import MultiStepForm from '../multi_step_form'

export default class PlanListItem {
  constructor(plan) {
    this.plan = plan
    this.parent = document.querySelector('.plan-list')
    const { name, price, project_details } = this.plan

    // render to the DOM
    this.parent.insertAdjacentHTML('beforeend', `
      <li class="plan-list-item" data-name="${name}" data-price="${price}">
        ${name} ${price} ${project_details[0]}
      </li>
    `)

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