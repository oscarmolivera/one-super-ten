class SeasonTeamRival < ApplicationRecord
  acts_as_tenant :tenant

  belongs_to :season_team
  belongs_to :rival

  validates :rival_id, uniqueness: { scope: :season_team_id }

  after_create :recalculate_standings
  after_destroy :recalculate_standings

  private

  def recalculate_standings
    # Recalculate standings for the season team and all its rivals
    StandingCalculatorService.new(season_team.tournament).recalculate_for_season_team(season_team)
  end
end