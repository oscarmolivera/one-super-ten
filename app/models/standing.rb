class Standing < ApplicationRecord
  belongs_to :tenant
  belongs_to :tournament
  belongs_to :stage, optional: true
  belongs_to :standable, polymorphic: true  # SeasonTeam or Rival

  validates :position, :points, :played, :wins, :draws, :losses, :goals_for, :goals_against,
            numericality: { greater_than_or_equal_to: 0 }
  validates_uniqueness_of :standable_id, scope: [:standable_type, :tournament_id, :stage_id]

  scope :for_season_team, ->(season_team) { where(season_team_id: season_team.id).order(position: :asc) }

  # Helper to compute goal_difference (call before save if needed)
  def calculate_goal_difference
    self.goal_difference = goals_for - goals_against
  end
end