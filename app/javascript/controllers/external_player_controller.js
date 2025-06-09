import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "table"]

  submit(event) {
    event.preventDefault()

    const formData = new FormData(this.formTarget)

    fetch("/external_players", {
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
        this.formTarget.reset()
        this.formTarget.closest('#new-external-player-form').style.display = "none"
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