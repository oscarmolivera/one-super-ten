// app/javascript/controllers/score_controller.js
import { Controller } from "@hotwired/stimulus"

/**
 * Owns the visible score number and its hidden input.
 * Listens for "score:set" to sync both.
 * If you render +/- buttons, wire them with click->score#increment / #decrement.
 */
export default class extends Controller {
  static targets = ["display", "input"]

  connect() {
    const v = parseInt(this.inputTarget.value, 10) || 0
    this.displayTarget.textContent = String(v)

    this._onSet = (e) => this.set(e.detail?.value ?? 0)
    this.element.addEventListener("score:set", this._onSet)
  }

  disconnect() {
    this.element.removeEventListener("score:set", this._onSet)
  }

  increment() { this.set((parseInt(this.inputTarget.value, 10) || 0) + 1) }
  decrement() { this.set(Math.max(0, (parseInt(this.inputTarget.value, 10) || 0) - 1)) }

  set(value) {
    const v = Math.max(0, parseInt(value, 10) || 0)
    this.inputTarget.value = v
    this.displayTarget.textContent = String(v)
  }
}