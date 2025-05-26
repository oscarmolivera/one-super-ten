class SeasonTeam < ApplicationRecord
  belongs_to :tenant
  belongs_to :category
  belongs_to :tournament

  has_many :season_team_players, dependent: :destroy
  has_many :players, through: :season_team_players

  validates :name, presence: true
end