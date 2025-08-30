module SeasonTeams
  class NextStageService
    def initialize(season_team)
      @season_team = season_team
    end
  
    def call
      return OpenStruct.new(success?: true) unless current_stage_closable?

      OpenStruct.new(success?: true, season_team: @season_team)      
    end

    def current_stage_closable?
      @season_team.stage_closable?
    end
  end
end
