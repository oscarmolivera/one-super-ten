// controllers/frame_loader_controller.js
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

    const allFrames = document.querySelectorAll("turbo-frame[id^='call_up_frame_']")
    allFrames.forEach(frame => {
      if (frame !== targetFrame && frame.innerHTML.trim() !== "") {
        frame.classList.remove("fadeOut")
        frame.classList.add("fadeOut")
        setTimeout(() => {
          frame.innerHTML = ""
          frame.classList.remove("fadeOut")
        }, 300)
      }
    })

    targetFrame.classList.remove("fadeOut")
    targetFrame.src = this.urlValue

    // ✅ After loading, always update the button to EDIT mode
    this.updateButtonToEdit()
  }

  updateButtonToEdit() {
    if (!this.hasButtonIdValue) return

    const button = document.getElementById(this.buttonIdValue)
    if (button) {
      button.innerHTML = `<i class="bi bi-people-fill me-1"></i> Editar Convocatoria`
    }
  }
}