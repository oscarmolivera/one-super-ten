class SeasonTeam < ApplicationRecord
  belongs_to :tenant
  belongs_to :category
  belongs_to :tournament

  belongs_to :coach, class_name: 'User', optional: true
  belongs_to :assistant_coach, class_name: 'User', optional: true
  belongs_to :team_assistant, class_name: 'User', optional: true

  has_many :season_team_players, dependent: :destroy
  has_many :players, through: :season_team_players

  has_many :season_team_rivals, dependent: :destroy
  has_many :rivals, through: :season_team_rivals

  has_many :home_matches, class_name: 'Match', foreign_key: :home_team_id, dependent: :nullify
  has_many :away_matches, class_name: 'Match', foreign_key: :away_team_id, dependent: :nullify

  has_one_attached :team_logo, dependent: :destroy
  has_many_attached :regulation_files


  has_one :inscription

  validates :name, presence: true
  validates :category_id, uniqueness: { scope: :tournament_id }

  def matches
    Match.for_category(category_id, tournament_id: tournament_id)
  end
end