import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  static values = { replacements: Array }

  connect() {
    this.update = this.update.bind(this)
  }

  update() {
    this.replacementsValue.forEach((obj) => {
      const {from, to} = obj

      this.inputTargets.forEach((input) => {
        const { value } = input

        if (value.includes(from)) {
          const newValue = value.replace(from, to)
          input.value = newValue
        }
      })
    })
  }

}
