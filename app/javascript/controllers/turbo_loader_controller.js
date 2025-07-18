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
          frame.removeAttribute("src")
          frame.classList.remove("fadeOut")
        }, 300)
      }
    })

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
      button.classList.add("btn-warning")
      button.innerHTML = `<i class="bi bi-people-fill me-1"></i> Editar Convocatoria`
    }
  }
}