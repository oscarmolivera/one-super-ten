import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkboxes"]

  selectAll() {
    this.checkboxesTarget.querySelectorAll('input[type="checkbox"]').forEach(cb => {
      cb.checked = true
    })
  }
}