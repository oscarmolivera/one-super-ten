// app/javascript/controllers/performance_counter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["value", "hidden"]

  connect() {
    // Tolerate missing targets so we can mount on multiple columns safely.
    if (this.hasHiddenTarget && this.hasValueTarget) {
      this.valueTarget.textContent = this.hiddenTarget.value || "0"
    }
    this.updateTeamScore()

    // Recalc after Turbo frame reloads that include this element
    this._onFrameLoad = () => {
      const frame = this._matchFrame()
      if (frame && frame.contains(this.element)) this.updateTeamScore()
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
    this.updateTeamScore()
  }

  decrement() {
    if (!this.hasHiddenTarget) return
    const curr = parseInt(this.hiddenTarget.value, 10) || 0
    if (curr > 0) {
      const next = curr - 1
      this.hiddenTarget.value = next
      if (this.hasValueTarget) this.valueTarget.textContent = String(next)
      this.updateTeamScore()
    }
  }

  updateTeamScore() {
    const host = this.element.closest("[data-match-id]")
    if (!host) return

    const matchId = host.dataset.matchId
    const playsAs = host.dataset.playsAs // "home" | "away"
    const frame = document.getElementById(`performance_frame_${matchId}`)
    if (!frame) return

    // 1) Sum all players' goals in this match frame
    const allHiddenGoals = frame.querySelectorAll(
      '[data-performance-counter-target="hidden"][name$="[goals_scored]"]'
    )
    const totalGoals = Array.from(allHiddenGoals).reduce((sum, el) => {
      const n = parseInt(el.value, 10)
      return sum + (Number.isFinite(n) ? n : 0)
    }, 0)

    // 2) Choose which score we should write (home -> team_score, away -> rival_score)
    const teamScoreInput = frame.querySelector('#match_team_score, input[name="match[team_score]"]')
    const rivalScoreInput = frame.querySelector('#match_rival_score, input[name="match[rival_score]"]')

    const targetInput = playsAs === "home" ? teamScoreInput : rivalScoreInput
    if (!targetInput) return

    // 3) Update the hidden input value (the one that submits with the form)
    targetInput.value = totalGoals

    // 4) Also update the visible number inside the "score" controller UI
    // Find a score controller that wraps BOTH the display and the input.
    // Prefer something close to the input (same turbo-frame region).
    const localHost = targetInput.closest('turbo-frame, [data-controller~="score"]') || frame
    const scoreBox = localHost.querySelector('[data-controller~="score"]')

    if (scoreBox) {
      // Ask the score controller to update both its hidden input and display
      scoreBox.dispatchEvent(
        new CustomEvent("score:set", { bubbles: true, detail: { value: totalGoals } })
      )
    } else {
      // Fallback: if no controller, try to update an adjacent display directly
      const display = localHost.querySelector('[data-score-target="display"]')
      if (display) display.textContent = String(totalGoals)
    }

    // Optional: broadcast that score changed
    frame.dispatchEvent(
      new CustomEvent("score:changed", { detail: { totalGoals, playsAs }, bubbles: true })
    )
  }

  _matchFrame() {
    const host = this.element.closest("[data-match-id]")
    if (!host) return null
    return document.getElementById(`performance_frame_${host.dataset.matchId}`)
  }
}