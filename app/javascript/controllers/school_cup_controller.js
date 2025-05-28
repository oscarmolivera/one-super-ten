import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["newCupLink", "schoolTab"]

  connect() {
    this.updateNewCupLink()
    console.log('schoolTab Controller')
  }

  updateNewCupLink() {
    const activeTab = this.schoolTabTargets.find(tab => tab.classList.contains("active"))
    if (activeTab) {
      const schoolId = activeTab.dataset.schoolId
      const baseUrl = this.newCupLinkTarget.href.split('?')[0]
      this.newCupLinkTarget.href = `${baseUrl}?school_id=${schoolId}`
    }
  }

  schoolTabTargetConnected(element) {
    element.addEventListener("click", () => {
      this.schoolTabTargets.forEach(tab => tab.classList.remove("active"))
      element.classList.add("active")
      this.updateNewCupLink()
    })
  }
}