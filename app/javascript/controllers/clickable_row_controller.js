import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  goToShow(event) {
    // Avoid redirect if clicking a link or button inside the row
    if (
      event.target.closest("a") ||
      event.target.closest("button") ||
      event.target.tagName === "A" ||
      event.target.tagName === "BUTTON"
    ) {
      return
    }

    window.location = this.urlValue
  }
}