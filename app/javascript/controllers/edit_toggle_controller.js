import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editableField", "button"]
  
toggle() {
  const isEditing = this.buttonTarget.innerText === "Editar Jugadores"

  this.editableFieldTargets.forEach(field => {
    const input = field.querySelector("input, select")
    const span = field.querySelector("span")

    if (isEditing) {
      // Switch to edit mode
      input.classList.remove("d-none")
      span.classList.add("d-none")
    } else {
      // Switch to view mode and update the span content
      input.classList.add("d-none")
      span.classList.remove("d-none")

      if (input.tagName === "INPUT") {
        span.textContent = input.value
      } else if (input.tagName === "SELECT") {
        span.textContent = input.selectedOptions[0]?.text || "—"
      }
    }
  })

  this.buttonTarget.innerText = isEditing ? "Finalizar Edición" : "Editar Jugadores"
}
}