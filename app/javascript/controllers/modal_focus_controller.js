import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("ModalFocusController: Connected")
    this.element.addEventListener("shown.bs.modal", () => {
      console.log("ModalFocusController: Modal shown, setting focus")
      const closeButton = this.element.querySelector(".btn-close")
      if (closeButton) {
        closeButton.focus()
        this.element.removeAttribute("aria-hidden")
      }
    })
  }
}