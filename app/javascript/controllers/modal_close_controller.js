// controllers/modal_close_controller.js
import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static values = { selector: String }

  connect() {
    console.log("ModalCloseController connected")
    const modalEl = document.querySelector(this.selectorValue)
    console.log(modalEl)

  }

  close() {
    console.log("Closing modal now") // debug
    const modalEl = document.querySelector(this.selectorValue)
    if (modalEl?.contains(document.activeElement)) document.activeElement.blur()

    const instance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl)
    instance.hide()
  }
}