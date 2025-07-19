import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    targetTab: String
  }

  connect() {
    // Wait for the DOM to fully load
    requestAnimationFrame(() => {
      const tabSelector = `a[data-bs-toggle="tab"][href="${this.targetTabValue}"]`
      const tabTrigger = document.querySelector(tabSelector)

      if (tabTrigger) {
        const tab = new bootstrap.Tab(tabTrigger)
        tab.show()
      }
    })
  }
}