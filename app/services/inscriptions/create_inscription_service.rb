module Inscriptions
  class CreateInscriptionService
    attr_reader :inscription

    def initialize(tournament:, current_user:, params:)
      @tournament = tournament
      @current_user = current_user
      @params = params
      @inscription = nil
    end

    def call
      ActiveRecord::Base.transaction do
        category = Category.find(@params[:category_id])

        @inscription = Inscription.new(
          tournament: @tournament,
          category: category,
          creator_id: @current_user.id
        )

        @inscription.build_season_team(
          tenant: ActsAsTenant.current_tenant,
          tournament: @tournament,
          category: category,
          name: "#{category.sub_name} - #{@tournament.name}",
          created_by_id: @current_user.id,
          coach_id: @params.dig(:season_team_attributes, :coach_id),
          assistant_coach_id: @params.dig(:season_team_attributes, :assistant_coach_id),
          team_assistant_id: @params.dig(:season_team_attributes, :team_assistant_id)
        )

        if @inscription.save
          AssignPlayersToSeasonTeamService.new(@inscription.season_team, @params).call
          set_season_team_stage(@inscription.season_team)
        end
      end

      @inscription
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Inscription creation failed: #{e.message}")
      nil
    end

    def set_season_team_stage(season_team)
      ActiveRecord::Base.transaction do
        Stage.create(
          tournament_id: season_team.tournament.id,
          season_team_id: season_team.id,
          name: 'first phase',
          stage_type: 0,
          order: 1
        )
      end
    end
  end
end