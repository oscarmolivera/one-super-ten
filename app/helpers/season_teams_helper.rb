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
    content_tag(:div, "Ganador", class: "winner-ribbon mt-1")
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
      if match.status == "played"
        home_class = "fs-42 text-dark text-glow-tied"
        away_class = "fs-42 text-dark text-glow-tied"
      else
      home_class = "fs-42 text-dark"
      away_class = "fs-42 text-dark"
      end
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

  def display_home_team_logo_and_name(match, show_highlights: false, season_team: nil)
    winner = winning_team(match) == :team if match.plays_as == "home"
    winner ||= winning_team(match) == :rival if match.plays_as == "away"

    if match.plays_as == "home"
      team = SeasonTeam.find(match.team_of_interest_id)
      html = display_team_logo_and_name(team, ActsAsTenant.current_tenant.name, winner: winner)
    else
      rival = Rival.find(match.rival_id)
      html = display_team_logo_and_name(rival, nil, winner: winner)
    end

    if show_highlights && match.status == "played" && match.plays_as == "home"
      html += render("season_teams/matches/highlights",
                    match: match,
                    season_team: season_team || match.team_of_interest)
    end

    html
  end

def display_away_team_logo_and_name(match, show_highlights: false, season_team: nil)
  winner =
    if match.plays_as == "away"
      winning_team(match) == :team
    elsif match.plays_as == "home"
      winning_team(match) == :rival
    end

  # Render the logo+name (your existing helper handles SeasonTeam vs Rival)
  html =
    if match.plays_as == "away"
      team = SeasonTeam.find(match.team_of_interest_id)
      display_team_logo_and_name(team, ActsAsTenant.current_tenant.name, winner: winner)
    else
      rival = Rival.find(match.rival_id)
      display_team_logo_and_name(rival, nil, winner: winner)
    end

  # Optionally append highlights when your season team is the away side and the match is played
  if show_highlights && match.status == "played" && match.plays_as == "away"
    html += render(
      "season_teams/matches/highlights",
      match: match,
      season_team: season_team || match.team_of_interest
    )
  end

  html
end

  def team_score_input_block(form, team:, score_attr:, label_text:, match:, role:, fallback_name: nil, placeholder_logo: "placeholder-logo.png", manual_controls: nil)
    manual_controls = role.to_s == "rival" if manual_controls.nil?

    content_tag :div, class: "col-md-6 d-flex align-items-center" do
      logo_and_name = content_tag(:div, class: "me-3 d-flex flex-column align-items-center justify-content-center") do
        logo_url =
          if team.present? && team.respond_to?(:team_logo) && team.team_logo.attached?
            team.team_logo
          else
            asset_path(placeholder_logo)
          end

        safe_join([
          image_tag(logo_url, alt: team.try(:name) || fallback_name, style: "max-height: 80px;"),
          content_tag(:h5, fallback_name || team.try(:name) || "Unknown Team")
        ])
      end

      score_input = content_tag(:div, class: "w-100 text-center") do
        form.label(score_attr, label_text, class: "form-label fw-semibold") +
        content_tag(:turbo_frame, id: "#{score_attr}_#{match.id}", class: "d-inline-block") do
          # Controller WRAPS both targets and carries the role
          content_tag(:div,
                      class: "d-inline-flex align-items-center gap-3",
                      data: { controller: "score", "score-role": role }) do

            # Decrement button (only for manual-controls)
            dec_btn = if manual_controls
              content_tag(:button, "–",
                type: "button",
                class: "btn btn-sm btn-outline-secondary rounded-circle d-flex align-items-center justify-content-center",
                style: "width:2rem;height:2rem;",
                data: { action: "click->score#decrement" }
              )
            else
              "".html_safe
            end

            # Visible number
            display = content_tag(:div,
                                  (match.send(score_attr) || 0).to_s,
                                  class: "display-4 fw-bold",
                                  data: { "score-target": "display" })

            # Increment button (manual-controls only)
            inc_btn = if manual_controls
              content_tag(:button, "+",
                type: "button",
                class: "btn btn-sm btn-outline-primary rounded-circle d-flex align-items-center justify-content-center",
                style: "width:2rem;height:2rem;",
                data: { action: "click->score#increment" }
              )
            else
              "".html_safe
            end

            # Hidden input
            hidden = form.hidden_field(score_attr,
                                       value: match.send(score_attr) || 0,
                                       id: "match_#{score_attr}",
                                       data: { "score-target": "input" })

            safe_join([dec_btn, display, inc_btn, hidden])
          end
        end
      end

      safe_join([logo_and_name, score_input])
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

  def edit_match_button(season_team, match, disabled: false)
    button_tag type: "button",
             class: "btn btn-outline-primary btn-sm#{' disabled' if disabled}",
             disabled: disabled,
               data: {
                 controller: "modal-loader",
                 action: "click->modal-loader#load",
                 "modal-loader-url-value": edit_match_modal_season_team_path(season_team, match_id: match.id),
                 "modal-loader-target-frame-value": "#match_modal_frame"
               } do
      safe_join([
        content_tag(:i, "", class: "bi bi-pencil-fill me-1"),
        " Editar"
      ])
    end
  end

  def call_up_button(match, disabled: false)
    if match.scheduled_at.present?
      if match.call_up.present?
        button_tag type: "button",
          id: "call_up_button_#{match.id}",
          class: "btn btn-warning btn-sm#{' disabled' if disabled}",
          disabled: disabled,
          data: {
                  controller: "call-up-loader",
                  action: "click->call-up-loader#load",
                  "call-up-loader-url-value": edit_or_new_call_up_url(match),
                  "call-up-loader-frame-value": "call_up_frame_#{match.id}",
                  "call-up-loader-button-id-value": "call_up_button_#{match.id}",
                  "call-up-loader-scheduled-at-value": "#{match.scheduled_at}"
                } do
          label = "Editar Convocatoria"
          safe_join([
            content_tag(:i, "", class: "bi bi-pencil-square me-1"),
            " #{label}"
          ])
        end
      else
        button_tag type: "button",
          id: "call_up_button_#{match.id}",
          class: "btn btn-primary btn-sm",
          data: {
                  controller: "call-up-loader",
                  action: "click->call-up-loader#load",
                  "call-up-loader-url-value": edit_or_new_call_up_url(match),
                  "call-up-loader-frame-value": "call_up_frame_#{match.id}",
                  "call-up-loader-button-id-value": "call_up_button_#{match.id}"
                } do
          label = "Crear Convocatoria"
          safe_join([
            content_tag(:i, "", class: "bi bi-people-fill me-1"),
            " #{label}"
          ])
        end
      end
    else
      button_tag type: "button",
        id: "call_up_button_#{match.id}",
        class: "btn btn-outline-secondary btn-sm disabled" do
        safe_join([
          content_tag(:i, "", class: "bi bi-x-octagon me-1"),
          "Ingresar Fecha del Partido"
        ])
      end
    end
  end

  def player_origin_class(player)
    origin = player_origin(player)

    case origin
    when :same_category
      "bg-light text-dark"
    when :other_category
      "bg-info-light bg-opacity-15 text-dark"
    when :external
      "bg-warning-light bg-opacity-15 text-dark"
    else
      ""
    end
  end

  def match_details_button(match, disabled: false)
    if match.scheduled_at.present? && Time.current >= match.scheduled_at
      if match.call_up.present?
        # Button is enabled if the match has started and has a call_up
        button_tag type: "button",
          id: "performance_button_#{match.id}",
          class: "btn btn-danger btn-sm#{' disabled' if disabled}",
          disabled: disabled,
          data: {
            controller: "match-details-loader",
            action: "click->match-details-loader#load",
            "match-details-loader-url-value": performance_form_match_path(match),
            "match-details-loader-frame-value": "performance_frame_#{ match.id }",
            "match-details-loader-button-id-value": "performance_button_#{ match.id }"
          } do
          label = "Actualizar Resultado"
          safe_join([
            content_tag(:i, "", class: "bi bi-file-text me-1"),
            " #{label}"
          ])
        end
      else
        # Disabled button if the match has started but no call_up exists
        button_tag type: "button",
          id: "performance_button_#{match.id}",
          class: "btn btn-outline-secondary btn-sm disabled" do
          safe_join([
            content_tag(:i, "", class: "bi bi-x-octagon me-1"),
            "Crear convocatoria primero"
          ])
        end
      end
    else
      # Disabled button if the match hasn't started yet
      button_tag type: "button",
        id: "performance_button_#{match.id}",
        class: "btn btn-outline-secondary btn-sm disabled" do
        safe_join([
          content_tag(:i, "", class: "bi bi-x-octagon me-1"),
          "Pendiente por Jugarse"
        ])
      end
    end
  end

  def call_up_player_origin(call_up_player)
    return :external if call_up_player.external_player_id.present?
    return :unknown unless call_up_player.player_category_id && call_up_player.call_up&.category_id

    if call_up_player.player_category_id == call_up_player.call_up.category_id
      :own_category
    else
      :other_category
    end
  end

  def call_up_player_td_class(origin)
    case origin
    when :own_category
      ""
    when :other_category
      "bg-info-light bg-opacity-15 text-dark"
    when :external
      "bg-warning-light bg-opacity-15 text-dark"
    else
      ""
    end
  end

  def team_highlights_for(match, season_team)
    return {} unless match.status == "played"

    stp = season_team.season_team_players.select(:player_id, :external_player_id)
    player_ids    = stp.map(&:player_id).compact
    external_ids  = stp.map(&:external_player_id).compact

    # If the team has no linked players/external players, bail early
    return {} if player_ids.empty? && external_ids.empty?

    # Build the scope WITHOUT Arel nils
    scopes = []
    scopes << MatchPerformance.where(performer_type: "Player",        performer_id: player_ids)    if player_ids.any?
    scopes << MatchPerformance.where(performer_type: "ExternalPlayer", performer_id: external_ids) if external_ids.any?

    perfs =
      if scopes.any?
        combined = scopes.reduce { |acc, s| acc.or(s) } # OR all non-empty scopes
        match.match_performances.includes(:performer).merge(combined)
      else
        MatchPerformance.none
      end

    group_count = ->(attr) do
      perfs
        .select { |p| p.public_send(attr).to_i.positive? }
        .group_by { |p| [p.performer_type, p.performer_id] }
        .map do |(_type, _id), ps|
          performer = ps.first.performer
          next unless performer # performer may be missing if the record was deleted
          {
            surname: surname_for(performer),
            count:   ps.sum { |p| p.public_send(attr).to_i }
          }
        end
        .compact
        .sort_by { |h| [-h[:count], h[:surname].to_s] }
    end

    scorers = group_count.call(:goals_scored)
    yellows = group_count.call(:yellow_cards)
    reds    = group_count.call(:red_cards)

    # GK stops (only if such a column exists)
    keeper_perf = perfs.find do |p|
      performer = p.performer
      pos = performer.respond_to?(:position) ? performer.position.to_s.downcase : ""
      %w[gk goalkeeper arquero portero].include?(pos)
    end

    keeper_data =
      if keeper_perf
        stops_attr = keeper_perf.respond_to?(:stops) ? :stops : (keeper_perf.respond_to?(:saves) ? :saves : nil)
        if stops_attr
          stops = keeper_perf.public_send(stops_attr).to_i
          { surname: surname_for(keeper_perf.performer), stops: stops } if stops.positive?
        end
      end

    { scorers: scorers, yellows: yellows, reds: reds, keeper: keeper_data }
  end

  def surname_for(person)
    return "" unless person
    person.try(:last_name).presence || person.try(:full_name).to_s.split.last.to_s
  end
end
