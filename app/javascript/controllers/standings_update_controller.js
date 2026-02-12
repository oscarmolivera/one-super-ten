import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="standings-update"
export default class extends Controller {
  static targets = ["standings-frame"]

  connect() {
    console.log("StandingsUpdateController connected")
  }

  updateStandings() {
    const frame = this.standingsFrameTarget
    if (!frame) {
      console.error("Standings frame target not found")
      return
    }
    else {
      frame.reload()
      console.log("Updating standings frame:", frame)
    }
  }
}
