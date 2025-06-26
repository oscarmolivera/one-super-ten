import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    targetModal: String,
    targetFrame: String
  }

  connect() { }

  load() {
    console.log(`CLICKED: ${this.targetModalValue}`)

    const frameId = this.targetFrameValue?.replace('#', '')
    const frame = document.getElementById(frameId)

    if (!frame) {
      console.warn(`No frame found with id '${this.targetFrameValue}'`)
      return
    }

    // Reset and reload the Turbo Frame
    frame.removeAttribute("src")
    frame.setAttribute("src", this.urlValue)

    frame.addEventListener(
      "turbo:frame-load",
      () => {
        const modal = new bootstrap.Modal(
          document.querySelector(this.targetModalValue)
        )
        modal.show()
      },
      { once: true }
    )
  }
}