module StagesHelper
  def render_tournament_stages(tournament_data, season_team)
    @reached_phases = season_team_phases(tournament_data, season_team)
    content_tag(:div, class: 'card-body px-4 py-3') do
      content_tag(:div, class: 'tabs-wrap') do
        concat render_nav_pills
        concat render_tab_content(tournament_data, season_team)
      end
    end
  end

  def enabled_phases(stage)
    return [] unless stage.stage_closable?

    current_value = Stage.phases[stage.phase]
    Stage.phases.select { |k, v| v > current_value }.keys
  end

  def phase_icon(phase)
    case phase
    when "primera_ronda" then "bi bi-1-circle-fill"
    when "segunda_ronda" then "bi bi-2-circle-fill"
    when "octavos" then "bi bi-8-square-fill"
    when "cuartos" then "bi bi-4-square-fill"
    when "semifinales" then "bi bi-2-square-fill"
    when "tercer_puesto" then "bi bi-3-circle-fill"
    when "final" then "bi bi-trophy-fill"
    when "terminado" then "bi bi-check-circle-fill"
    else "bi bi-question-circle"
    end
  end


  private

  def render_nav_pills
    content_tag(:ul, class: 'nav nav-pills mb-20', role: 'tablist') do
      Stage.phases.map.with_index do |(phase_name, _phase_value), index|
        content_tag(:li, class: 'nav-item', role: 'presentation') do
          content_tag(:a, 
                      class: "nav-link #{index == @reached_phases.first ? 'active' : ''} #{@reached_phases.include?(index) ? '' : 'disabled'}",  
                      href: "#phase#{index}", 
                      role: 'tab',
                      aria: { 
                        selected: index == @reached_phases.first ? 'true' : 'false',
                        disabled: @reached_phases.include?(index) ? nil : 'true'
                      },
                      tabindex: @reached_phases.include?(index) ? nil : '-1',
                      data: { 
                        bs_title: @reached_phases.include?(index) ? nil : 'No participas en esta fase',
                        bs_toggle: @reached_phases.include?(index) ? 'tab' : nil
                      }
          ) do
            safe_join([
              content_tag(:span, tag.i(class: phase_icon_class(phase_name)), class: 'hidden-sm-up'),
              content_tag(:span, phase_name.humanize, class: 'hidden-xs-down')
            ])
          end
        end
      end.join.html_safe
    end
  end

  def render_tab_content(tournament_data, season_team)
    content_tag(:div, class: 'tab-content tabcontent-border min-h-75', data: { controller: 'match-details-busy' }) do
      Stage.phases.map.with_index do |(phase_name, _phase_value), index|
        content_tag(:div, 
                    class: "tab-pane #{index.zero? ? 'active' : ''}", 
                    id: "phase#{index}", 
                    role: 'tabpanel') do
          render_phase_tab_content(tournament_data, season_team, phase_name, index)
        end
      end.join.html_safe
    end
  end

  def render_phase_tab_content(tournament_data, season_team, phase_name, index)
    stage_group = tournament_data[:matches_by_stage].find { |sg| sg[:stage].phase == phase_name }
    content = add_new_match_button(season_team, phase_name, index)
    content += if stage_group&.[](:matches)&.any?
      render( partial: 'season_teams/matches/matches_display', locals: {
              tournament_data: tournament_data, 
              stage_matches: { matches_by_stage: [stage_group] }, 
              season_team: season_team, phase_name: phase_name 
            })
    else
      content_tag(:div, "No hay partidos en la fase #{phase_name.humanize}.", class: 'alert alert-info text-center mb-0')
    end

    content
  end

  def render_first_tab_content(tournament_data, season_team)
    render_phase_tab_content(tournament_data, season_team, 'primera_ronda', 0)
  end

  def render_second_phase_tab_content(tournament_data, season_team)
    render_phase_tab_content(tournament_data, season_team, 'segunda_ronda', 1)
  end

  def render_placeholder_tab_content(phase_name)
    content_tag(:div, class: 'placeholder-content p-4') do
      content_tag(:p, "Contenido para la fase #{phase_name.humanize} (por implementar)")
    end
  end

  def phase_icon_class(phase_name)
    case phase_name
    when 'primera_ronda', 'segunda_ronda' then 'fa-solid fa-flag-checkered'
    when 'octavos', 'cuartos' then 'fa-solid fa-medal'
    when 'semifinales', 'tercer_puesto', 'final' then 'fa-solid fa-trophy'
    else 'fa-solid fa-flag'
    end
  end

  def season_team_phases(tournament_data, season_team)
    tournament_data[:matches_by_stage]
      .map { |sg| Stage.phases[sg[:stage].phase] }
      .uniq
      .sort
  end

  def add_new_match_button(season_team, phase_name, index)
    if can_add_new_match?(season_team, phase_name)
      content_tag(:button,
                            id: "phase_#{index}_add_match",
                            type: 'button',
                            class: 'waves-effect waves-light btn btn-success mb-0',
                            data: {
                              controller: 'modal-loader',
                              action: 'click->modal-loader#load',
                              match_details_busy_target: "button",
                              modal_loader_url_value: matches_modal_season_team_path(season_team),
                              modal_loader_target_frame_value: '#match_modal_frame'
                            },
                            style: 'position: absolute; right: 15px;') do
        safe_join([
          tag.i(class: 'fa-solid fa-square-plus me-1'),
          'Agregar Partido'
        ])
      end
    else
      content_tag(:button,
                            type: 'button',
                            class: 'waves-effect waves-light btn btn-info mb-0 disabled',
                            style: 'position: absolute; right: 15px;',
                            title: 'No puedes agregar más partidos en esta fase') do
        safe_join([
          tag.i(class: 'fa-solid fa-square-plus me-1'),
          'Agregar Partido'
        ])
      end
    end
  end

  def can_add_new_match?(season_team, phase_name)
    season_team.current_stage&.phase == phase_name
  end
end