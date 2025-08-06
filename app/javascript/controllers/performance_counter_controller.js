import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["value", "hidden"]

  connect() {
    this.valueTarget.textContent = this.hiddenTarget.value
  }

  increment() {
    let val = parseInt(this.hiddenTarget.value, 10) || 0
    this.hiddenTarget.value = ++val
    this.valueTarget.textContent = val
  }

  decrement() {
    let val = parseInt(this.hiddenTarget.value, 10) || 0
    if (val > 0) {
      this.hiddenTarget.value = --val
      this.valueTarget.textContent = val
    }
  }
}