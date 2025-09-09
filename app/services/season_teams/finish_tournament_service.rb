class FinishTournamentService
  def initialize(season_team)
    @season_team = season_team
  end

  def call
    @season_team.tournament.update(status: :completed)
    # Add side effects like emailing or logging
  end
end