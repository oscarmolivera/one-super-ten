class Match < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tournament
  belongs_to :team_of_interest, class_name: 'SeasonTeam'
  belongs_to :rival_season_team, class_name: 'SeasonTeam', optional: true
  belongs_to :rival, optional: true

  has_many :call_ups, dependent: :destroy
  has_many :categories, through: :call_ups
  has_many :line_ups, dependent: :destroy
  has_many :match_reports, dependent: :destroy
  has_many :match_performances, dependent: :destroy

  enum :match_type, { friendly: 0, tournament: 1, practice: 2 }
  enum :plays_as, { home: 0, away: 1 }
  enum :location_type, {home_field: 0, away_field: 1, neutral: 2 }
  enum :status, { created: 0, scheduled: 1, played: 2, cancelled: 3 }

  validates :match_type, :plays_as, presence: true

  def opponent_name
    rival&.name || rival_season_team&.name || "Desconocido"
  end

  def home_team_name
    plays_as == "home" ? team_of_interest.name : opponent_name
  end

  def away_team_name
    plays_as == "away" ? team_of_interest.name : opponent_name
  end
end