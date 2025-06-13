module SeasonTeams
  class TournamentDataService
    def initialize(season_team)
      @season_team = season_team
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
        #matches: @season_team.matches,
        top_scorers: top_scorers,
        standings: standings
      }
    end
  
    private
  
    def top_scorers
      #@season_team.players.order(goals: :desc).limit(10)
      false
    end
  
    def standings
      #TournamentStanding.for_category(@season_team.category, @season_team.tournament)
      true
    end
  end
end
