module SeasonTeams
  class TournamentDataService
    def initialize(season_team, pagy, pagy_rivals)
      @season_team = season_team
      @pagy = pagy
      @rivals = pagy_rivals
    end
  
    def data
      {
        tournament: @season_team.tournament,
        category: @season_team.category,
        cup: @season_team.tournament.cup,
        players: @season_team.season_team_players.includes(:player),
        coach: @season_team.coach,
        assistant: @season_team.assistant_coach,
        team_assistant: @season_team.team_assistant,
        #call_ups: @season_team.call_ups,
        favorite_rivals: Rival.tenant_favorites,
        pagy: @pagy,
        rivals: @rivals
      }
    end
  end
end
