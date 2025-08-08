import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "input"]

  connect() {
    console.log("Score controller connected");
    this.updateDisplay();
  }

  increment() {
    let currentScore = parseInt(this.inputTarget.value) || 0;
    this.inputTarget.value = currentScore + 1;
    this.updateDisplay();
  }

  updateDisplay() {
    this.displayTarget.textContent = this.inputTarget.value;
  }
}