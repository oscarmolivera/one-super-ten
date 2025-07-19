module Inscriptions
  class UpdateInscriptionService
    attr_reader :inscription

    def initialize(inscription:, params:)
      @inscription = inscription
      @params = params
      @season_team = @inscription.season_team
    end

    def call
      return false unless @season_team

      ActiveRecord::Base.transaction do
        @season_team.update!(
          coach_id: @params.dig(:season_team_attributes, :coach_id),
          assistant_coach_id: @params.dig(:season_team_attributes, :assistant_coach_id),
          team_assistant_id: @params.dig(:season_team_attributes, :team_assistant_id)
        )

        AssignPlayersToSeasonTeamService.new(@season_team, @params).call
        @inscription.save!
      end

      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to update inscription: #{e.message}")
      false
    end
  end
end