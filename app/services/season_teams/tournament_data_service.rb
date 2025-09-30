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
        matches_by_stage: @season_team.stages.includes(:matches).order(:order).map do |stage|
          {
            stage: stage,
            matches: stage.matches.ordered_by_status_and_schedule
          }
        end,
        favorite_rivals: Rival.tenant_favorites,
        pagy: @pagy,
        rivals: @rivals,
        standings: @season_team.stages.last.standings.order(points: :desc, goal_difference: :desc, goals_for: :desc)
      }
    end
  end
end