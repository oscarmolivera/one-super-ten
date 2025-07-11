module SeasonTeamsHelper
  ## -------------------------------
  ##  Player Info Helpers
  ## -------------------------------

  def suggested_player_info(player, category)
    last_stp = SeasonTeamPlayer.joins(:season_team)
                               .where(player: player, season_teams: { category_id: category.id })
                               .order(created_at: :desc).first

    {
      jersey_number: last_stp&.jersey_number || player.jersey_number || "",
      jersey_source: source_label(last_stp&.jersey_number, player.jersey_number),
      position: last_stp&.position || player.position || "",
      position_source: source_label(last_stp&.position, player.position)
    }
  end

  def source_label(last_value, player_value)
    if last_value.present?
      "Último equipo"
    elsif player_value.present?
      "Perfil jugador"
    else
      "Aleatorio"
    end
  end

  def st_player_origin_label(player)
    player.external_player_id.present? ? ExternalPlayer.find(player.external_player_id).notes : ''
  end

  def st_player_category(player)
    player.origin == "external" ? nil : Category.find(player.category_id).sub_name
  end

  def player_origin(player)
    return :external if player.external_player_id.present?
    return :same_category if player.category_id == player.season_team.category_id

    :other_category
  end

  def row_class_for(origin)
    { external: 'list-group-item-warning', other_category: 'list-group-item-info' }[origin] || ''
  end

  def icon_for(origin)
    { external: 'fa-user-plus', other_category: 'fa-arrows-turn-to-dots' }[origin]
  end

  def st_list_label(player)
    case player_origin(player)
    when :other_category then 'Refuerzo: '
    when :external       then 'EXTERNO*'
    else ''
    end
  end

  def badge_class_for(origin)
    {
      external: 'badge bg-warning text-dark px-3 py-2',
      other_category: 'badge bg-info text-muted px-3 py-2'
    }[origin] || 'badge bg-secondary text-dark px-3 py-2'
  end

  ## -------------------------------
  ##  Match Result Helpers
  ## -------------------------------

  def team_score_data(match)
    team_score = match.team_score || 0
    rival_score = match.rival_score || 0

    if match.plays_as == "home"
      { your_score: team_score, opponent_score: rival_score, home_score: team_score, away_score: rival_score }
    else
      { your_score: team_score, opponent_score: rival_score, home_score: rival_score, away_score: team_score }
    end
  end

  def winning_team(match)
    data = team_score_data(match)
    if data[:your_score] > data[:opponent_score]
      :team
    elsif data[:opponent_score] > data[:your_score]
      :rival
    else
      nil
    end
  end

  def winner_badge
    content_tag(:div, "Winner", class: "winner-ribbon mt-1")
  end

  def display_match_result(match)
    data = team_score_data(match)

    if data[:your_score] > data[:opponent_score]
      home_class = "fs-42 text-navy-blue text-glow"
      away_class = "fs-42 text-wine"
    elsif data[:opponent_score] > data[:your_score]
      home_class = "fs-42 text-wine"
      away_class = "fs-42 text-navy-blue text-glow"
    else
      home_class = "fs-42 text-dark"
      away_class = "fs-42 text-dark"
    end

    # Ensure correct order for plays_as
    if match.plays_as == "home"
      home_score, away_score = data[:home_score], data[:away_score]
    else
      home_score, away_score = data[:home_score], data[:away_score]
    end

    safe_join([
      content_tag(:span, home_score, class: home_class),
      " : ",
      content_tag(:span, away_score, class: away_class)
    ])
  end

  ## -------------------------------
  ##  Logo and Badge Helpers
  ## -------------------------------

  def display_team_logo_and_name(team, fallback_name = nil, placeholder_logo = "placeholder-logo.png", winner: false)
    content_tag :div, class: "mb-3 text-center" do
      logo_div = content_tag(:div, class: "team-logo mb-2 mx-auto d-flex align-items-center justify-content-center") do
        logo_url =
          if team.present? && team.respond_to?(:team_logo) && team.team_logo.attached?
            team.team_logo
          else
            asset_path(placeholder_logo)
          end

        image_tag(
          logo_url,
          alt: team.try(:name) || fallback_name,
          style: "max-height: 50px;"
        )
      end

      name_tag = content_tag(:h5, fallback_name || team.try(:name) || "Unknown Team")
      badge = winner ? winner_badge : nil

      safe_join([logo_div, name_tag, badge].compact)
    end
  end

  def display_home_team_logo_and_name(match)
    winner = winning_team(match) == :team if match.plays_as == "home"
    winner ||= winning_team(match) == :rival if match.plays_as == "away"

    if match.plays_as == "home"
      team = SeasonTeam.find(match.team_of_interest_id)
      display_team_logo_and_name(team, ActsAsTenant.current_tenant.name, winner: winner)
    else
      rival = Rival.find(match.rival_id)
      display_team_logo_and_name(rival, nil, winner: winner)
    end
  end

  def display_away_team_logo_and_name(match)
    winner = winning_team(match) == :team if match.plays_as == "away"
    winner ||= winning_team(match) == :rival if match.plays_as == "home"

    if match.plays_as == "away"
      team = SeasonTeam.find(match.team_of_interest_id)
      display_team_logo_and_name(team, ActsAsTenant.current_tenant.name, winner: winner)
    else
      rival = Rival.find(match.rival_id)
      display_team_logo_and_name(rival, nil, winner: winner)
    end
  end

  ## -------------------------------
  ##  Other Small Helpers
  ## -------------------------------

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
    authorized ? "h-170" : "h-140"
  end

  def display_plays_as_badge(match)
    badge_class, text = match.plays_as == "home" ? ["bg-primary", "LOCAL"] : ["bg-secondary", "VISITANTE"]
    content_tag(:div, text, class: "badge #{badge_class}")
  end

  def display_status_badge(status)
    case status
    when 'created'   then content_tag(:div, 'Sin Fecha', class: "badge bg-instagram")
    when 'scheduled' then content_tag(:div, 'Agendado', class: "badge bg-github")
    when 'played'    then content_tag(:div, 'Jugado', class: "badge badge-school-1 text-dark")
    else "alfo"
    end
  end

  def display_match_schedule(match)
    if match.scheduled_at.present?
      formatted_date = match.scheduled_at.strftime("%d %b %Y")
      formatted_time = match.scheduled_at.strftime("%H:%M")
      content_tag :div, class: "mb-2 text-muted small" do
        safe_join(["#{formatted_date} at ", content_tag(:strong, formatted_time)])
      end
    else
      content_tag(:div, "Falta por Agendar", class: "mb-2 text-muted small")
    end
  end

  def match_stage(stage)
    return "Primera Ronda" if stage.name == 'first phase'
  end

  def edit_or_new_call_up_url(match)
    if match.call_up.present?
      edit_call_up_path(match.call_up)
    else
      new_match_call_up_path(match)
    end
  end
end