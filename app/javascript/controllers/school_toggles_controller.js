// app/javascript/controllers/school_toggles_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "label", "feedback"]

  connect() {
    this.validate()
    this.form = this.element.closest("form")

    if (this.form) {
      this.form.addEventListener("submit", this.onSubmit)
    }

    this.inputTargets.forEach(input =>
      input.addEventListener("change", () => this.validate())
    )
  }

  disconnect() {
    if (this.form) {
      this.form.removeEventListener("submit", this.onSubmit)
    }
  }

  validate() {
    const checkedCount = this.inputTargets.filter(input => input.checked).length
    const valid = checkedCount > 0

    if (this.hasFeedbackTarget) {
      this.feedbackTarget.style.display = valid ? "none" : "block"
    }

    this.labelTargets.forEach(label => {
      label.classList.toggle("text-danger", !valid)
    })

    return valid
  }

  onSubmit = (event) => {
    if (!this.validate()) {
      event.preventDefault()
      event.stopImmediatePropagation()
    }
  }
}