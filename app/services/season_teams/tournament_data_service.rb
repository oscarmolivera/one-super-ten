module SeasonTeams
  class TournamentDataService
    require 'ostruct'  # For creating in-memory Standing-like objects

    def initialize(season_team, pagy, pagy_rivals)
      @season_team = season_team
      @pagy = pagy
      @rivals = pagy_rivals
    end

    def data
      {
        tournament: @season_team.tournament,
        category: @season_team.category,
        cup: @season_team.tournament.cup,
        players: @season_team.season_team_players.includes(:player),
        coach: @season_team.coach,
        assistant: @season_team.assistant_coach,
        team_assistant: @season_team.team_assistant,
        matches_by_stage: @season_team.stages.includes(:matches).order(:order).map do |stage|
          {
            stage: stage,
            matches: stage.matches.ordered_by_status_and_schedule
          }
        end,
        favorite_rivals: Rival.tenant_favorites,
        pagy: @pagy,
        rivals: @rivals,
        standings: combined_group_standings,
        external_matches: @season_team.external_matches,
        player_statistics: SeasonTeams::PlayerStatisticsService.new(@season_team, @season_team.tournament).player_statistics
      }
    end

    private

    # New method to compute combined standings for primera_ronda and segunda_ronda
    def combined_group_standings
      group_stages = @season_team.stages.where(phase: [:primera_ronda, :segunda_ronda]).includes(:standings)

      # If no group stages, fallback to original behavior
      return @season_team.stages.last.standings.order(points: :desc, goal_difference: :desc, goals_for: :desc) if group_stages.empty?

      # Collect all standings from these stages
      all_standings = group_stages.flat_map(&:standings)

      # Group by standable and sum stats
      combined_stats = all_standings.group_by(&:standable).transform_values do |standings_group|
        {
          points: standings_group.sum(&:points),
          played: standings_group.sum(&:played),
          wins: standings_group.sum(&:wins),
          draws: standings_group.sum(&:draws),
          losses: standings_group.sum(&:losses),
          goals_for: standings_group.sum(&:goals_for),
          goals_against: standings_group.sum(&:goals_against),
          goal_difference: standings_group.sum(&:goals_for) - standings_group.sum(&:goals_against)
        }
      end

      # Sort by points DESC, goal_difference DESC, goals_for DESC (matching original)
      sorted_stats = combined_stats.sort_by do |_, stats|
        [-stats[:points], -stats[:goal_difference], -stats[:goals_for]]
      end

      # Create ranked Standing-like objects (OpenStruct for view compatibility)
      sorted_stats.each_with_index.map do |(standable, stats), index|
        OpenStruct.new(
          position: index + 1,
          standable: standable,
          points: stats[:points],
          played: stats[:played],
          wins: stats[:wins],
          draws: stats[:draws],
          losses: stats[:losses],
          goals_for: stats[:goals_for],
          goals_against: stats[:goals_against],
          goal_difference: stats[:goal_difference]
        )
      end
    end
  end
end