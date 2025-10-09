class SeasonTeamRival < ApplicationRecord
  acts_as_tenant :tenant

  belongs_to :season_team
  belongs_to :rival

  validates :rival_id, uniqueness: { scope: :season_team_id }
  validates :active, inclusion: { in: [true, false] }  # Enforce boolean post-migration

  # Scopes for tournament-specific active/inactive rivals
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # Your existing callbacks
  after_create :recalculate_standings
  after_destroy :recalculate_standings

  # New: Optional sync callbacks to align with global Rival.active
  # (Prevents global inactivation from ignoring tournament-specific overrides)
  after_create :sync_global_active
  after_update :sync_global_active_if_needed

  private

  def recalculate_standings
    # Recalculate standings for the season team and all its rivals
    StandingCalculatorService.new(season_team.tournament).recalculate_for_season_team(season_team)
  end

  # New: Sync with global rival.active on creation (if unset or mismatched)
  def sync_global_active
    if active.nil? || active != rival.active
      update_column(:active, rival.active)  # Use update_column to avoid callbacks loop
    end
  end

  # New: If global active changes to false, inactivate this association
  def sync_global_active_if_needed
    if saved_change_to_rival_id?  # Only if rival association changed
      sync_global_active
    elsif rival&.active_was == true && rival.active == false  # Detect global change
      update_column(:active, false)
      recalculate_standings  # Trigger your recalc if global inactivation affects standings
    end
  end
end