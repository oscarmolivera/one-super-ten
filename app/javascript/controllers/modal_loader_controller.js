import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    targetModal: String
  }

  load() {
    const frame = document.getElementById("rival_modal_frame")

    if (!frame.src) {
      frame.src = this.urlValue
    }

    // Wait for the Turbo Frame to load before showing the modal
    frame.addEventListener("turbo:frame-load", () => {
      const modal = new bootstrap.Modal(document.querySelector(this.targetModalValue))
      modal.show()
    }, { once: true })
  }
}