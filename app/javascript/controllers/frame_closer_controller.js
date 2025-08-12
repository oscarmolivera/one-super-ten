import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { buttonId: String }

  close() {
    console.log("Closing frame:", this.element.id)
    this.element.classList.add("fadeOut")
    setTimeout(() => this.element.innerHTML = "", 300)
  }
}