import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Ensure aria-hidden is removed when modal is initialized
    this.element.removeAttribute("aria-hidden")
    this.element.addEventListener("shown.bs.modal", () => {
      const closeButton = this.element.querySelector(".btn-close")
      if (closeButton) {
        closeButton.focus()
      }
    })
    // Debug ARIA state on hide
    // this.element.addEventListener("hidden.bs.modal", () => {
    //   console.log("ModalFocusController: Modal hidden, ARIA state:", this.element.getAttribute("aria-hidden"))
    // })
  }
}