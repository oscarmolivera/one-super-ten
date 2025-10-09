class SeasonTeams::StandingsController < ApplicationController
  
  def standing
    @season_team = SeasonTeam.find(params[:id])
    @standing = @season_team.standings.last
    
    @rival_standings = @season_team.rivals.map(&:standings).flatten.select { |s| s.tournament == @season_team.tournament }
  end
end