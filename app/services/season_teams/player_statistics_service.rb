module SeasonTeams
  class PlayerStatisticsService
    def initialize(season_team, tournament)
      @season_team = season_team
      @tournament = tournament
    end

    def player_statistics
      # Get all players from the season team
      player_ids = @season_team.season_team_players.includes(:player).map(&:player_id).compact
      external_player_ids = @season_team.season_team_players.includes(:external_player).map(&:external_player_id).compact

      # Return empty array if no players
      return [] if player_ids.empty? && external_player_ids.empty?

      # Get all match performances for this tournament for these players
      performances = MatchPerformance
        .where(tournament: @tournament)
        .where(
          MatchPerformance.arel_table[:performer_type].eq('Player').and(
            MatchPerformance.arel_table[:performer_id].in(player_ids)
          ).or(
            MatchPerformance.arel_table[:performer_type].eq('ExternalPlayer').and(
              MatchPerformance.arel_table[:performer_id].in(external_player_ids)
            )
          )
        )
        .includes(:performer)

      # Aggregate statistics by performer
      stats_by_performer = performances.group_by(&:performer)

      # Create statistics for each performer, including those with no performances
      all_performers = (@season_team.season_team_players.includes(:player, :external_player).map do |stp|
        if stp.player_id.present?
          [stp.player, 'Player']
        elsif stp.external_player_id.present?
          [stp.external_player, 'ExternalPlayer']
        end
      end.compact)

      all_performers.map do |performer, performer_type|
        performer_performances = stats_by_performer[performer] || []
        
        {
          performer: performer,
          performer_type: performer_type,
          goals: performer_performances.sum(&:goals_scored),
          assists: performer_performances.sum(&:assists),
          yellow_cards: performer_performances.sum(&:yellow_cards),
          red_cards: performer_performances.sum(&:red_cards),
          keeper_blocks: calculate_keeper_blocks(performer, performer_performances)
        }
      end.sort_by { |stat| [-stat[:goals], -stat[:assists]] }
    end

    private

    def calculate_keeper_blocks(performer, performances)
      # Check if performer is a goalkeeper based on position
      is_keeper = performer.respond_to?(:position) && 
                  performer.position.to_s.downcase.in?(['portero', 'gk', 'goalkeeper', 'arquero'])
      
      return 0 unless is_keeper
      
      # For now, we don't have a specific keeper_blocks field in MatchPerformance
      # This could be added later or calculated differently
      # For demonstration, we'll use a placeholder calculation
      # You might want to add a keeper_blocks field to MatchPerformance or calculate this differently
      0 # Placeholder - replace with actual keeper blocks calculation
    end
  end
end
