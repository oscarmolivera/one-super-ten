// modal_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    targetFrame: String
  }

  load() {
    const frameId = this.targetFrameValue?.replace('#', '')
    const frame = document.getElementById(frameId)

    if (!frame) {
      console.warn(`No frame found with id '${frameId}'`)
      return
    }

    // Reset and reload the Turbo Frame
    frame.removeAttribute("src")
    frame.setAttribute("src", this.urlValue)
  }
}