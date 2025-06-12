module Inscriptions
  class FormDataLoader
    attr_reader :category, :season_team

    def initialize(tournament:, category:, season_team: nil)
      @tournament = tournament
      @category = category
      @season_team = season_team || default_season_team
    end

    def call
      {
        inscription: @tournament.inscriptions.build(category: @category),
        season_team: @season_team,
        previous_team_player_ids: @season_team.players.pluck(:id),
        previous_external_player_ids: @season_team.season_team_players.where.not(external_player_id: nil).pluck(:external_player_id),
        category_players: @category.players.where(tenant: ActsAsTenant.current_tenant),
        lower_category: lower_category,
        lower_players: lower_category&.players&.where(tenant: ActsAsTenant.current_tenant) || [],
        upper_category: upper_category,
        upper_players: upper_category&.players&.where(gender: 'mujer', tenant: ActsAsTenant.current_tenant) || [],
        external_players: ::EligibleExternalPlayersQuery.new(@category).call
      }
    end

    private

    def default_season_team
      SeasonTeam
        .where(category: @category, tenant: ActsAsTenant.current_tenant)
        .order(created_at: :desc)
        .first || SeasonTeam.new
    end

    def lower_category
      @category.lower_category
    end

    def upper_category
      @category.upper_category
    end
  end
end