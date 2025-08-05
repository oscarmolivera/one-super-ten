module SeasonTeams
  class MatchPerformanceTableService
    Row = Struct.new(:call_up_player, :performer, :performer_type, :performance)

    def initialize(match)
      @match = match
    end

    def rows
      call_up_players = @match.call_up&.call_up_players&.includes(:player) || []
      performances_by_pid = @match.match_performances.index_by { |mp| [mp.performer_type, mp.performer_id] }

      call_up_players.map do |cup|
        performer = cup.player
        performer_type = "Player"
        performance = performances_by_pid[[performer_type, performer.id]] ||
                      @match.match_performances.build(
                        performer: performer,
                        performer_type: performer_type,
                        performer_id: performer.id
                      )
        Row.new(cup, performer, performer_type, performance)
      end
    end
  end
end