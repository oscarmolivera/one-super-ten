import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "rulesContainer"]

  connect() {
    console.log("CategoryRulesController connected");
  }

  add(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.rulesContainerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest("[data-category-rules-target='rule']")
    if (wrapper.dataset.newRecord === "true") {
      // Just remove new unsaved element
      wrapper.remove()
    } else {
      // Mark for _destroy
      wrapper.querySelector("input[name*='_destroy']").value = "1"
      wrapper.style.display = "none"
    }
  }
}