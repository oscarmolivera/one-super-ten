// app/javascript/controllers/external_player_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "table"]

  connect() {
    // Ensure form is appended only once
    const placeholder = document.getElementById("external-player-form-container-placeholder")
    const formWrapper = document.getElementById("external-player-form-wrapper")
    if (placeholder && formWrapper && !placeholder.hasChildNodes()) {
      placeholder.appendChild(formWrapper)
      formWrapper.style.display = "block"
    }
  }

  submit(event) {
    event.preventDefault()

    console.log("Submitting external player form...")

    const form = this.formTarget
    const formData = new FormData(form)

    fetch(form.action, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: formData
    })
      .then(response => response.json())
      .then(data => {
        if (data.id) {
          this.appendPlayerRow(data)
          form.reset()
          form.closest("#new-external-player-form").style.display = "none"
          document.querySelector(".btn.btn-outline-primary").style.display = "block"
        } else {
          alert("Error al guardar el refuerzo externo.")
        }
      })
  }

  appendPlayerRow(player) {
    const row = document.createElement("tr")
    row.innerHTML = `
      <td>
        <input type="checkbox" name="inscription[external_player_ids][]" value="${player.id}" checked class="form-check-input" id="player_${player.id}">
        <label for="player_${player.id}">${player.first_name} ${player.last_name}</label>
      </td>
      <td>${player.jersey_number}</td>
      <td>${player.position}</td>
    `
    this.tableTarget.querySelector("tbody").appendChild(row)
  }
}
