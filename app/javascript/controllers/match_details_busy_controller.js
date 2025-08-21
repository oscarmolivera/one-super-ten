import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    busy: { type: Number, default: 0 },
  }
  static targets = ["button"]


  connect() {
    document.addEventListener("busy:start", e => this.hideAddMatchButton())
    document.addEventListener("busy:end", e => this.showAddMatchButton())
  }

  hideAddMatchButton() {
    this.busyValue += 1
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.add("d-none")
    }
  }

  showAddMatchButton() {
    if (this.busyValue != 0) {
      this.busyValue -= 1
    }
    
    if (this.busyValue === 0) {
      this.buttonTarget.classList.remove("d-none")
      this.buttonTarget.classList.add("fadeIn")
      setTimeout(() => {
        this.buttonTarget.classList.remove("fadeIn")
      }, 500) // Remove fadeIn class after animation
    }
  }
}