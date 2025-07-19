import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { frameId: String, url: String }

  load() {
    const frame = document.getElementById(this.frameIdValue)
    if (frame && !frame.src) {
      frame.src = this.urlValue
    }
  }
  }