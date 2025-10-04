module Rivals
  class CreateService
    def initialize(season_team:, existing_rival_id:, rival_params:)
      @season_team = season_team
      @existing_rival_id = existing_rival_id
      @rival_params = rival_params
    end

    def call
      @rival = if @existing_rival_id.present?
                 Rival.find(@existing_rival_id)
               else
                 Rival.new(@rival_params.merge(tenant: ActsAsTenant.current_tenant))
               end

    if @rival.save
      @season_team.rivals << @rival unless @season_team.rivals.exists?(@rival.id)
      recalculate_standings
      ServiceResponse.success(rival: @rival)
    else
      ServiceResponse.error(rival: @rival)
    end
    end

    def recalculate_standings
      # Recalculate standings for the season team and all its rivals
      StandingCalculatorService.new(@season_team.tournament).recalculate_for_season_team(@season_team)
    end
  end
end