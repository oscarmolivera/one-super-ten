import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tournament-match-stages"
export default class extends Controller {
  static values = {
    seasonTeamId: Number,
    nextPhaseName: String,
    finishTournament: Boolean
  }

  connect() {
    console.log('Tournament Match Stages controller connected');
  }

  confirm(event) {
    const message = this.finishTournamentValue
      ? "¿Estás seguro de que deseas finalizar la participación en el torneo?"
      : "¿Estás seguro de que deseas cerrar la fase actual del torneo? Esta acción no se puede deshacer.";

    if (confirm(message)) {
      this.nextStage();
    }
  }

  nextStage() {
    const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const seasonTeamId = this.seasonTeamIdValue;
    const url = this.finishTournamentValue
      ? `/season_teams/${seasonTeamId}/finish_tournament`
      : `/season_teams/${seasonTeamId}/advance_stage?next_phase=${this.nextPhaseNameValue}`;

    fetch(url, {
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
          response.text().then(text => {
            const actionText = this.finishTournamentValue ? 'finalizar el torneo' : 'cerrar la fase';
            alert(`Error al ${actionText}: ${text}`);
          });
        }
      })
      .catch(error => {
        const actionText = this.finishTournamentValue ? 'finalizar el torneo' : 'cerrar la fase';
        alert(`Error de red al ${actionText}: ${error}`);
      });
  }
}