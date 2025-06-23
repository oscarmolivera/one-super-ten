import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "homeRadio",
    "opponentSelect",
    "seasonTeamInput",
    "homeTeamInput",
    "awayTeamInput"
  ]

  submit(event) {
    const playHome = this.homeRadioTarget.checked
    const opponentId = this.opponentSelectTarget.value
    const seasonTeamId = this.seasonTeamInputTarget.value

    if (playHome) {
      this.homeTeamInputTarget.value = seasonTeamId
      this.awayTeamInputTarget.value = opponentId
    } else {
      this.homeTeamInputTarget.value = opponentId
      this.awayTeamInputTarget.value = seasonTeamId
    }
  }
}