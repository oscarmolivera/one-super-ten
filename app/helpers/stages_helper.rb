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
    content_tag(:div, class: 'tab-content tabcontent-border min-h-75', data: {controller: 'match-details-busy'}) do
      Stage.phases.map.with_index do |(phase_name, _phase_value), index|
        content_tag(:div, 
                    class: "tab-pane #{index.zero? ? 'active' : ''}", 
                    id: "phase#{index}", 
                    role: 'tabpanel') do
          if index.zero?
            concat render_first_tab_content(tournament_data, season_team)
          else
            concat render_placeholder_tab_content(phase_name)
          end
        end
      end.join.html_safe
    end
  end

  def render_first_tab_content(tournament_data, season_team)
    content = content_tag(:button,
                          id: 'phase_0_add_match',
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

    content += if tournament_data[:matches].any?
      render(partial: 'season_teams/matches/matches_display', locals: { tournament_data: tournament_data })
    else
      content_tag(:div, 'No hay partidos en esta fase.', class: 'alert alert-info text-center mb-0')
    end

    content
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
    Stage.where(season_team_id: 59, tournament_id: 41)
          .pluck(:phase)
          .uniq
          .map { |phase_name| Stage.phases[phase_name] }
          .sort
  end
end