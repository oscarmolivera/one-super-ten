module RivalsHelper
  def tournament_active?(rival)
    rival = @season_team&.season_team_rivals&.find_by(rival_id: rival.id)
    return true if rival&.active?
    false
  end

  def is_rival_active?(standing)
    rival = @season_team&.season_team_rivals&.find_by(rival_id: standing.standable.id)
    return true if rival&.active?
    false
  end
end