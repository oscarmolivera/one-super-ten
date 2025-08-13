// controllers/match_details_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    frame: String,
    buttonId: String
  }

  load() {
    const frame = document.getElementById(this.frameValue)
    if (!frame) return

    if (frame.getAttribute("src") === this.urlValue) frame.removeAttribute("src")

    const onLoad = () => {
      const modalEl = frame.querySelector("#matchModal") // <- query inside the frame
      if (!modalEl) return

      document.body.appendChild(modalEl)                 // escape stacking context
      const modal = new bootstrap.Modal(modalEl)
      modal.show()

      modalEl.addEventListener("hidden.bs.modal", () => {
        modal.dispose()
        modalEl.remove()
        frame.removeAttribute("src")                     // optional: force fresh load
      }, { once: true })

      frame.removeEventListener("turbo:frame-load", onLoad)
    }

    frame.addEventListener("turbo:frame-load", onLoad, { once: true })
    frame.setAttribute("src", this.urlValue)

    this.updateButtonToEdit?.()
  }

  updateButtonToEdit() {
    if (!this.hasButtonIdValue) return

    const button = document.getElementById(this.buttonIdValue)
    if (button) {
      button.classList.remove("btn-outline-primary")
      button.classList.add("btn-light-outline")
      button.innerHTML = `<i class="bi bi-cone-striped"></i> Editar Detalles`
    }
  }
}
