module SeasonTeams
  class NextStageService
    def initialize(season_team, next_phase = nil)
      @season_team = season_team
      @next_phase = next_phase
    end
  
    def call
      if @next_phase == :finish_tournament
        finish_tournament
      else
        return OpenStruct.new(success?: true) unless current_stage_closable?
        create_next_stage_matches
        OpenStruct.new(success?: true, season_team: @season_team)      
      end
    end

    def finish_tournament
      return OpenStruct.new(success?: false, errors: ["Cannot finish tournament without closing current stage"]) unless current_stage_closable?
      
      @season_team.update(active: false)
      OpenStruct.new(success?: true, season_team: @season_team)
    end

    def current_stage_closable?
      @season_team.stage_closable?
    end

    def create_next_stage_matches
      Stage.create(
        tournament_id: @season_team.tournament_id,
        season_team_id: @season_team.id,
        name: @next_phase,
        stage_type: set_stage_type(@next_phase),
        order: set_order(@next_phase),
        phase: set_phase(@next_phase)
      )
    end

    def set_stage_type(next_phase)
      case next_phase
      when "primera_ronda", "segunda_ronda"
        0
      else
        1
      end
    end

    def set_order(next_phase)
      case next_phase
      when "primera_ronda", "segunda_ronda"
        1
      when "octavos"
        2
      when "cuartos"
        3
      when "semifinales"
        4
      when "tercer_puesto"
        5
      when "final"
        6
      else
        8
      end
    end

    def set_phase(next_phase)
      case next_phase
      when "primera_ronda"
        0
      when "segunda_ronda"
        1
      when "octavos"
        2
      when "cuartos"
        3
      when "semifinales"
        4
      when "tercer_puesto"
        5
      when "final"
        6
      else
        7
      end
    end
  end
end