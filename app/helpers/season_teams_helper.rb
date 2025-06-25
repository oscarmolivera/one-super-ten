module SeasonTeamsHelper
  def suggested_player_info(player, category)
    last_stp = SeasonTeamPlayer.joins(:season_team)
                .where(player: player, season_teams: { category_id: category.id })
                .order(created_at: :desc).first

    # Determine jersey number
    jersey_number = last_stp&.jersey_number || player.jersey_number || ""
    jersey_source = if last_stp&.jersey_number.present?
                      "Último equipo"
                    elsif player.jersey_number.present?
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
  
  def st_player_origin_lable(player)
    if player.external_player_id.present?
      ExternalPlayer.find(player.external_player_id).notes
    else
      ''
    end
  end

  def st_player_category(player)
    if player.origin == "external"
      nil
    else
      Category.find(player.category_id).sub_name
    end
  end

  def player_origin(player)
    return :external if player.external_player_id.present?
  
    return :same_category if player.category_id == player.season_team.category_id
  
    :other_category
  end

  def row_class_for(origin)
    case origin
      when :external       then 'list-group-item-warning'
      when :other_category then 'list-group-item-info'
    else '' 
    end
  end

  def icon_for(origin)
    case origin
    when :external       then 'fa-user-plus'
    when :other_category then 'fa-arrows-turn-to-dots'
    else nil
    end
  end

  def st_list_lable(player)
    return 'Refuerzo: ' if player_origin(player) == :other_category
    return 'EXTERNO*' if player_origin(player) == :external
    ''
  end

  def badge_class_for(origin)
    case origin
    when :external       then 'badge bg-warning text-dark px-3 py-2'
    when :other_category then 'badge bg-info text-muted px-3 py-2'
    else 'badge bg-secondary text-dark px-3 py-2'
    end
  end

  def rival_team_logo(rival, options = {})
    default_classes = "rounded-circle shadow-sm"
    style = options[:style] || "width: 60px; height: 60px;"
    classes = [options[:class], default_classes].compact.join(" ")

    if rival.team_logo.attached?
      image_tag rival.team_logo.variant(resize_to_limit: [60, 60]),
                options.merge(alt: "#{rival.name} logo", class: classes, style: style, loading: "lazy")
    else
      image_tag "placeholder-logo.png",
                options.merge(alt: "No logo", class: classes, style: style)
    end
  end

  def rival_card_height(authorized)
    if authorized
      "h-170"
    else
      "h-140"
    end
  end
end
