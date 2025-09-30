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
        set_rival_standing_record
        ServiceResponse.success(rival: @rival)
      else
        ServiceResponse.error(rival: @rival)
      end
    end

    def set_rival_standing_record

      Standing.create(
        tenant_id: ActsAsTenant.current_tenant.id,
        tournament_id: @season_team.tournament.id,
        stage_id: Stage.where(season_team: @season_team)&.last.id,
        standable_type: 'Rival',
        standable_id: @rival.id,
        position: @season_team.standings.count + 1,
        points: 0,
        played: 0,
        wins: 0,
        draws: 0,
        losses: 0,
        goals_for: 0,
        goals_against: 0,
        goal_difference: 0
      )      
    end
  end
end