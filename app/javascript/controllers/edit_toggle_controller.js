import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editableField", "button"]
  
  toggle() {
    this.editableFieldTargets.forEach(field => {
      const input = field.querySelector("input, select")
      const span = field.querySelector("span")
      if (input.classList.contains("d-none")) {
        input.classList.remove("d-none")
        span.classList.add("d-none")
        this.buttonTarget.innerText = "Finalizar Edición"
      } else {
        input.classList.add("d-none")
        span.classList.remove("d-none")
        this.buttonTarget.innerText = "Editar Jugadores"
      }
    })
  }
}