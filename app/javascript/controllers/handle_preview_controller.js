import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]

  connect() {
    this.update() // ✅ ensures correct value on page load
  }

  update() {
    const handle = this.inputTarget.value.trim()
    this.outputTarget.innerText = handle === "" ? "nombre-publico" : handle
  }
}