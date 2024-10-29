import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String } // Dynamically set URL

  initialize() {
    this.search = this.search.bind(this)
  }

  connect() {
    this.clearResults()
    this.inputTarget.addEventListener("input", this.search)
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.search)
  }

  search() {
    const query = this.inputTarget.value.trim()
    if (!query) {
      this.clearResults()
      return
    }

    // Fetch results from the provided URL with the query parameter
    fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.showResults(data.results)
      })
  }

  showResults(results) {
    this.clearResults()

    results.forEach(html => {
      const item = document.createElement("div")

      item.innerHTML = html
      item
        .querySelector(".autocomplete-item")
        .addEventListener("click", event => this.selectItem(event.currentTarget))

      this.resultsTarget.appendChild(item.firstElementChild) // Append parsed HTML
    })
  }

  selectItem(item) {
    this.inputTarget.value = item.textContent.trim() // Fill input with selected item's text

    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
  }
}
