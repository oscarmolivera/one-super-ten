class StandingCalculator
  def initialize(tournament, stage = nil)
    @tournament = tournament
    @stage = stage
  end

  def calculate
    Standing.transaction do
      # Clear existing for scope
      @tournament.standings.where(stage: @stage).destroy_all

      # Gather all participating teams (SeasonTeams + Rivals)
      teams = @tournament.season_teams + @tournament.season_teams.flat_map(&:rivals).uniq

      # Matches in scope (completed only)
      matches = @tournament.matches.where(status: :completed)  # Assuming status enum includes :completed
      matches = matches.where(stage: @stage) if @stage

      # Compute stats for each team
      stats = teams.each_with_object({}) do |team, hash|
        hash[team] = { points: 0, played: 0, wins: 0, draws: 0, losses: 0, gf: 0, ga: 0 }
      end

      matches.each do |match|
        toi = match.team_of_interest  # SeasonTeam
        rival = match.rival_season_team || match.rival

        next unless toi && rival  # Skip invalid

        stats[toi][:played] += 1
        stats[rival][:played] += 1
        stats[toi][:gf] += match.team_score.to_i
        stats[toi][:ga] += match.rival_score.to_i
        stats[rival][:gf] += match.rival_score.to_i
        stats[rival][:ga] += match.team_score.to_i

        if match.team_score > match.rival_score
          stats[toi][:wins] += 1
          stats[toi][:points] += 3
          stats[rival][:losses] += 1
        elsif match.team_score < match.rival_score
          stats[toi][:losses] += 1
          stats[rival][:wins] += 1
          stats[rival][:points] += 3
        else
          stats[toi][:draws] += 1
          stats[rival][:draws] += 1
          stats[toi][:points] += 1
          stats[rival][:points] += 1
        end
      end

      # Sort by points desc, then goal diff, etc.
      sorted_stats = stats.sort_by { |team, s| [-s[:points], - (s[:gf] - s[:ga]), -s[:gf]] }

      # Create Standings
      sorted_stats.each_with_index do |(team, s), index|
        Standing.create!(
          tenant: @tournament.tenant,
          tournament: @tournament,
          stage: @stage,
          standable: team,
          position: index + 1,
          points: s[:points],
          played: s[:played],
          wins: s[:wins],
          draws: s[:draws],
          losses: s[:losses],
          goals_for: s[:gf],
          goals_against: s[:ga],
          goal_difference: s[:gf] - s[:ga]
        )
      end
    end
  end
end