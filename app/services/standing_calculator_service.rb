class StandingCalculatorService
  def initialize(tournament, stage = nil)
    @tournament = tournament
    @stage = stage
  end

  def calculate
    if @stage
      calculate_for_season_team(@stage.season_team, @stage)
    else
      # For tournament-wide, calculate per SeasonTeam (per Category) to avoid mixing
      @stage.season_teams.each do |season_team|
        calculate_for_season_team(season_team, nil)
      end
    end
  end
  
  private
  
  def calculate_for_season_team(season_team, stage)
    Standing.transaction do
      # Clear existing standings for this scope (per season_team/category via standable)
      scope = @tournament.standings.where(stage: stage)
      scope = scope.where(standable: [season_team] + season_team.rivals) if stage # Further scope to avoid deleting unrelated
      scope.destroy_all

      # Gather teams: this SeasonTeam + its specific Rivals
      associated_rivals = season_team.rivals.uniq

      # Matches: scoped to stage if provided, and involving this season_team
      regular_matches = @tournament.matches.where(team_of_interest: season_team)
      regular_matches = regular_matches.where(stage: stage) if stage

      regular_teams = regular_matches.flat_map { |m| [m.team_of_interest, m.rival_season_team || m.rival] }.compact.uniq

      # External matches: involving this season_team's rivals (group games)
      external_matches = @tournament.external_matches.where(home_rival: associated_rivals).or(@tournament.external_matches.where(away_rival: associated_rivals))
      external_matches = external_matches.where(stage: stage) if stage

      external_teams = external_matches.flat_map { |em| [em.home_rival, em.away_rival] }.compact.uniq

      # Unique teams: SeasonTeam + its rivals + any from matches
      teams = ([season_team] + associated_rivals + regular_teams + external_teams).uniq

      # Initialize stats
      stats = teams.each_with_object({}) do |team, hash|
        hash[team] = { points: 0, played: 0, wins: 0, draws: 0, losses: 0, gf: 0, ga: 0 }
      end

      # Process regular matches (only played ones)
      completed_regular_matches = regular_matches.where(status: :played) # Fixed from :completed
      completed_regular_matches.each do |match|
        toi = match.team_of_interest
        rival = match.rival_season_team || match.rival
        next unless toi && rival && teams.include?(toi) && teams.include?(rival) # Ensure scoped

        update_stats(stats, toi, rival, match.team_score.to_i, match.rival_score.to_i)
      end

      # Process external matches
      completed_external_matches = external_matches.where(status: :played) # Assume similar enum
      completed_external_matches.each do |match|
        home = match.home_rival
        away = match.away_rival
        next unless home && away && teams.include?(home) && teams.include?(away)

        update_stats(stats, home, away, match.home_score.to_i, match.away_score.to_i)
      end

      # Sort and create standings
      sorted_stats = stats.sort_by { |team, s| [-s[:points], -(s[:gf] - s[:ga]), -s[:gf]] }

      sorted_stats.each_with_index do |(team, s), index|
        Standing.create!(
          tenant: @tournament.tenant,
          tournament: @tournament,
          stage: stage,
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

  def update_stats(stats, team1, team2, score1, score2)
    stats[team1][:played] += 1
    stats[team2][:played] += 1
    stats[team1][:gf] += score1
    stats[team1][:ga] += score2
    stats[team2][:gf] += score2
    stats[team2][:ga] += score1

    if score1 > score2
      stats[team1][:wins] += 1
      stats[team1][:points] += 3
      stats[team2][:losses] += 1
    elsif score1 < score2
      stats[team1][:losses] += 1
      stats[team2][:wins] += 1
      stats[team2][:points] += 3
    else
      stats[team1][:draws] += 1
      stats[team2][:draws] += 1
      stats[team1][:points] += 1
      stats[team2][:points] += 1
    end
  end
end