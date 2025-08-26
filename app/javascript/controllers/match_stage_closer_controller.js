import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="match-stage-closer"
export default class extends Controller {
  static values = {
    seasonTeamId: Number,
    stageId: Number,
    closeUrl: String,
  }
  connect() {
  }
}
