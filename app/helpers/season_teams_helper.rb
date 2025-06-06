module SeasonTeamsHelper
  def suggested_player_info(player, category)
    last_stp = SeasonTeamPlayer.joins(:season_team)
                .where(player: player, season_teams: { category_id: category.id })
                .order(created_at: :desc).first

    # Determine jersey number
    jersey_number = last_stp&.jersey_number || player.player_profile.jersey_number || ""
    jersey_source = if last_stp&.jersey_number.present?
                      "Último equipo"
                    elsif player.player_profile.jersey_number.present?
                      "Perfil jugador"
                    else
                      "Aleatorio"
                    end

    # Determine position
    position = last_stp&.position || player.position || ""
    position_source = if last_stp&.position.present?
                        "Último equipo"
                      elsif player.position.present?
                        "Perfil jugador"
                      else
                        "Aleatorio"
                      end

    {
      jersey_number: jersey_number,
      jersey_source: jersey_source,
      position: position,
      position_source: position_source
    }
  end
end