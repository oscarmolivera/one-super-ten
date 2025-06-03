class SeasonTeam < ApplicationRecord
  belongs_to :tenant
  belongs_to :category
  belongs_to :tournament

  has_many :season_team_players, dependent: :destroy
  has_many :players, through: :season_team_players

  has_one :inscription

  validates :name, presence: true
  validates :category_id, uniqueness: { scope: :tournament_id }
end