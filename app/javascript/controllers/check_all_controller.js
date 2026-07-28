import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  toggle() {
    const allChecked = this.checkboxTargets.every((checkbox) => checkbox.checked)
    this.checkboxTargets.forEach((checkbox) => { checkbox.checked = !allChecked })
  }
}
