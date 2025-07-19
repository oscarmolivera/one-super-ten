// controllers/call_up_cleaner_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { callUpId: Number, buttonId: String }

  cleanup() {
    if (!this.hasCallUpIdValue || this.callUpIdValue === 0) return

    const token = document.querySelector('meta[name="csrf-token"]').content

    fetch(`/call_ups/${this.callUpIdValue}/cleanup`, {
      method: "DELETE",
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": token
      }
    }).then(response => {
      if (response.status === 204) {
        this.updateButtonToAdd()
      }
    })
  }

  updateButtonToAdd() {
    if (!this.hasButtonIdValue) return

    const button = document.getElementById(this.buttonIdValue)
    if (button) {
      button.innerHTML = `<i class="bi bi-people-fill me-1"></i> Crear Convocatoria`
    }
  }
}