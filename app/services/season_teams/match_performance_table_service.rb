module SeasonTeams
  class MatchPerformanceTableService
    Row = Struct.new(:call_up_player, :performer, :performer_type, :performance)

    def initialize(match)
      @match = match
    end

    def rows
      call_up_players = @match.call_up&.call_up_players&.includes(:player, :external_player) || []
      performances_by_pid = @match.match_performances.index_by { |mp| [mp.performer_type, mp.performer_id] }

      call_up_players.map do |cup|
        if cup.player_id.present?
          performer = cup.player
          performer_type = "Player"
        elsif cup.external_player_id.present?
          performer = cup.external_player
          performer_type = "ExternalPlayer"
        else
          performer = nil
          performer_type = nil
        end

        # Skip if neither performer is present (shouldn't happen, but for safety)
        next unless performer

        performance = performances_by_pid[[performer_type, performer.id]] ||
                      @match.match_performances.build(
                        performer: performer,
                        performer_type: performer_type,
                        performer_id: performer.id
                      )
        Row.new(cup, performer, performer_type, performance)
      end.compact
    end
  end
end