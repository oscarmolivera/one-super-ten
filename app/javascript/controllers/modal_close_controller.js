// controllers/modal_close_controller.js
import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static values = { selector: String }

  close() {
    const selector = this.selectorValue

    const modalEl =
      document.querySelector(selector) ||
      window.parent.document.querySelector(selector)

    if (!modalEl) {
      console.warn("Modal not found:", selector)
      return
    }

    const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl)
    modal.hide()
  }
}