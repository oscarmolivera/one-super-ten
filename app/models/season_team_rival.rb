class SeasonTeamRival < ApplicationRecord
  acts_as_tenant :tenant

  belongs_to :season_team
  belongs_to :rival

  validates :rival_id, uniqueness: { scope: :season_team_id }
end