import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  toggleAll() {
    const allChecked = this.checkboxTargets.every(cb => cb.checked)
    this.checkboxTargets.forEach(cb => cb.checked = !allChecked)
  }
}