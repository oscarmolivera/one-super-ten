// controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static values = { selector: String }

  connect() {
    window.addEventListener("modal:close", () => this.close())
  }

  close() {
    const modalEl = document.querySelector(this.selectorValue)

    // ✅ 1. Remove focus from any element inside modal
    if (modalEl?.contains(document.activeElement)) {
      document.activeElement.blur()
    }

    // ✅ 2. Hide the modal safely
    if (modalEl) {
      const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl)
      modalInstance.hide()
    }
  }
}