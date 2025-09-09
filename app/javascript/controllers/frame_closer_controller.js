import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { buttonId: String }

  close() {
    this.element.dispatchEvent(
      new CustomEvent("busy:end", { bubbles: true, detail: { value: 'FrameCloser Pressed' } })
    )
    this.element.classList.add("fadeOut")
    setTimeout(() => this.element.innerHTML = "", 300)
  }
}