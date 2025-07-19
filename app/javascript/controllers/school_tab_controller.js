import { Controller } from "@hotwired/stimulus"
import { Tab } from "bootstrap"

// Connects to data-controller="school-tab"
export default class extends Controller {
  connect() {
    document.addEventListener("DOMContentLoaded", () => {
      this.activateTabFromHash()
    })

    this.activateTabFromHash() // in case already loaded
  }

  activateTabFromHash() {
    const hash = window.location.hash
    if (hash && hash.startsWith("#school-pane-")) {
      const targetTab = document.querySelector(`button[data-bs-target="${hash}"]`)
      if (targetTab) {
        const tab = new Tab(targetTab)
        tab.show()
      }
    }
  }
}