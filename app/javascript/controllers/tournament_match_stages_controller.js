import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tournament-next-stage"
export default class extends Controller {
  static values = { seasonTeamId: Number }
  connect() {
  }

  confirm() { 
    // if (confirm("¿Estás seguro de que deseas cerrar la fase actual del torneo? Esta acción no se puede deshacer.")) {
    //   this.nextStage()
    // }
    this.nextStage()
  }

  nextStage() {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const seasonTeamId = this.seasonTeamIdValue;

    
    fetch(`/season_teams/${seasonTeamId}/advance_stage`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': token
      },
      body: JSON.stringify({})
    })
    .then(response => {
      if (response.ok) {
        window.location.reload();
      } else {
        response.text().then(text => alert(`Error al cerrar la fase: ${text}`));
      }
    })
    .catch(error => {
      alert(`Error de red al cerrar la fase: ${error}`);
    });
  }
}
