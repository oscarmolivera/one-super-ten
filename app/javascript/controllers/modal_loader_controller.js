// app/javascript/controllers/modal_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    targetFrame: String   // e.g. "#rival_modal_frame" or "#match_modal_frame"
  }

  load() {
    const frameId = (this.targetFrameValue || "").replace("#", "")
    const frame = document.getElementById(frameId)
    if (!frame) return

    // If same URL, force reload
    if (frame.getAttribute("src") === this.urlValue) frame.removeAttribute("src")

    // When the frame finishes loading the modal HTML…
    const onLoad = () => {
      // Grab the first .modal inside the frame (or use a specific id if you prefer)
      const modalEl = frame.querySelector(".modal")
      if (!modalEl) { frame.removeEventListener("turbo:frame-load", onLoad); return }

      // Move modal to <body> to escape stacking contexts/backdrop issues
      document.body.appendChild(modalEl)

      // Init + show Bootstrap modal
      const modal = bootstrap.Modal.getOrCreateInstance(modalEl)
      modal.show()

      // Clean up when closed
      modalEl.addEventListener("hidden.bs.modal", () => {
        modal.dispose()
        modalEl.remove()
        frame.removeAttribute("src") // optional: force a fresh load next time
      }, { once: true })

      frame.removeEventListener("turbo:frame-load", onLoad)
    }

    frame.addEventListener("turbo:frame-load", onLoad, { once: true })
    frame.setAttribute("src", this.urlValue)
  }
}