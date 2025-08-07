import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["value", "hidden"];

  connect() {
    this.valueTarget.textContent = this.hiddenTarget.value;
    this.updateTeamScore();
  }

  increment() {
    let val = parseInt(this.hiddenTarget.value, 10) || 0;
    this.hiddenTarget.value = ++val;
    this.valueTarget.textContent = val;
    this.updateTeamScore();
  }

  decrement() {
    let val = parseInt(this.hiddenTarget.value, 10) || 0;
    if (val > 0) {
      this.hiddenTarget.value = --val;
      this.valueTarget.textContent = val;
      this.updateTeamScore();
    }
  }

  updateTeamScore() {
    const matchId = this.element.closest("[data-match-id]").dataset.matchId;
    const playAs = this.element.closest("[data-match-id]").dataset.playsAs;

    // Calculate total goals by summing all hidden fields in the match frame
    const frame = document.querySelector(`#performance_frame_${matchId}`);
    const allHiddenGoals = frame.querySelectorAll('[data-performance-counter-target="hidden"][name$="[goals_scored]"]');
    const totalGoals = Array.from(allHiddenGoals).reduce((sum, hidden) => sum + (parseInt(hidden.value, 10) || 0), 0);

    const teamScoreInput = frame.querySelector('[name="match[team_score]"]');
    const rivalScoreInput = frame.querySelector('[name="match[rival_score]"]');

    if (playAs === "home" && teamScoreInput) {
      teamScoreInput.value = totalGoals;
    } else if (rivalScoreInput) {
      rivalScoreInput.value = totalGoals;
    }
  }

}