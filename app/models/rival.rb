class Rival < ApplicationRecord

  has_one_attached :team_logo, dependent: :destroy

  has_many :season_team_rivals, dependent: :destroy
  has_many :season_teams, through: :season_team_rivals

  validates :name, presence: true, length: { maximum: 120 }
end