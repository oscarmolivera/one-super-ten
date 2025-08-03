// controllers/match_details_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    frame: String,
    buttonId: String
  }

  load() {
    const targetFrame = document.getElementById(this.frameValue)
    if (!targetFrame) return

    // 🔑 Force reload if URL is the same
    if (targetFrame.getAttribute("src") === this.urlValue) {
      targetFrame.removeAttribute("src")
    }

    targetFrame.classList.remove("fadeOut")
    targetFrame.setAttribute("src", this.urlValue)

    this.updateButtonToEdit()
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
