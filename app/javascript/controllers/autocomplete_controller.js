import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String } // Dynamically set URL

  initialize() {
    this.search = this.search.bind(this)
    this.clearResults = this.clearResults.bind(this)
    this.slowlyClearResults = this.slowlyClearResults.bind(this)
  }

  connect() {
    this.clearInput()
    this.clearResults()

    this.inputTarget.addEventListener("input", this.search)
    this.inputTarget.addEventListener("focus", this.search)
    this.inputTarget.addEventListener("blur", this.slowlyClearResults)
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.search)
    this.inputTarget.removeEventListener("focus", this.search)
    this.inputTarget.removeEventListener("blur", this.slowlyClearResults)
  }

  search() {
    const query = this.inputTarget.value.trim()
    if (!query) {
      this.clearResults()
      return
    }

    const url = new URL(this.urlValue, window.location.origin);
    url.searchParams.set("q", query);

    // Fetch results from the provided URL with the query parameter
    fetch(url.toString())
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

    this.clearInput()
    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
  }

  slowlyClearResults() {
    setTimeout(this.clearResults, 200)
  }

  clearInput() {
    this.inputTarget.value = ""
  }
}
