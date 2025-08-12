// app/javascript/controllers/performance_counter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["value", "hidden"]

  connect() {
    if (this.hasHiddenTarget && this.hasValueTarget) {
      this.valueTarget.textContent = this.hiddenTarget.value || "0"
    }
    this.updateTenantScore()

    this._onFrameLoad = () => {
      const frame = this._matchFrame()
      if (frame && frame.contains(this.element)) this.updateTenantScore()
    }
    document.addEventListener("turbo:frame-load", this._onFrameLoad)
  }

  disconnect() {
    document.removeEventListener("turbo:frame-load", this._onFrameLoad)
  }

  increment() {
    if (!this.hasHiddenTarget) return
    const next = (parseInt(this.hiddenTarget.value, 10) || 0) + 1
    this.hiddenTarget.value = next
    if (this.hasValueTarget) this.valueTarget.textContent = String(next)
    this.updateTenantScore()
  }

  decrement() {
    if (!this.hasHiddenTarget) return
    const curr = parseInt(this.hiddenTarget.value, 10) || 0
    if (curr > 0) {
      const next = curr - 1
      this.hiddenTarget.value = next
      if (this.hasValueTarget) this.valueTarget.textContent = String(next)
      this.updateTenantScore()
    }
  }

  // IMPORTANT: Only updates the TENANT score box, never the rival.
  updateTenantScore() {
    const frame = this._matchFrame()
    if (!frame) return

    // Sum all goals from counters inside this match frame
    const allHiddenGoals = frame.querySelectorAll(
      '[data-performance-counter-target="hidden"][name$="[goals_scored]"]'
    )
    const totalGoals = Array.from(allHiddenGoals).reduce((sum, el) => {
      const n = parseInt(el.value, 10)
      return sum + (Number.isFinite(n) ? n : 0)
    }, 0)

    // Find the tenant score widget (we'll mark it with data-score-role="tenant")
    const tenantBox = frame.querySelector('[data-controller~="score"][data-score-role="tenant"]')
    if (!tenantBox) return

    // Notify the score controller to update both its hidden input and display
    tenantBox.dispatchEvent(
      new CustomEvent("score:set", { bubbles: true, detail: { value: totalGoals } })
    )

    // Optional broadcast
    frame.dispatchEvent(
      new CustomEvent("score:changed", { detail: { totalGoals, role: "tenant" }, bubbles: true })
    )
  }

  _matchFrame() {
    const host = this.element.closest("[data-match-id]")
    if (!host) return null
    return document.getElementById(`performance_frame_${host.dataset.matchId}`)
  }
}