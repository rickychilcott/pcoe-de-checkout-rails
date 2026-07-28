import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }

  copy() {
    navigator.clipboard.writeText(this.textValue)
    const original = this.element.textContent
    this.element.textContent = "✓"
    setTimeout(() => { this.element.textContent = original }, 1000)
  }
}
