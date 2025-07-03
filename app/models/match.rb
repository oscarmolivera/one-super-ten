class Match < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tournament
  belongs_to :stage, optional: true 
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
  enum :status, { created: 0, scheduled: 1, played: 2, cancelled: 3, reschedule: 4, postponed: 5 }

  before_validation :set_match_status

  validates :match_type, :plays_as, presence: true

  scope :ordered_by_status_and_schedule, -> {
    order(Arel.sql(<<~SQL.squish))
      CASE status
        WHEN #{statuses[:created]} THEN 0
        WHEN #{statuses[:scheduled]} THEN 1
        WHEN #{statuses[:reschedule]} THEN 2
        WHEN #{statuses[:postponed]} THEN 3
        WHEN #{statuses[:played]} THEN 4
        WHEN #{statuses[:cancelled]} THEN 5
        ELSE 6
      END ASC,
      COALESCE(scheduled_at, '9999-12-31') ASC
    SQL
  }

  def opponent_name
    rival&.name || rival_season_team&.name || "Desconocido"
  end

  def home_team_name
    plays_as == "home" ? team_of_interest.name : opponent_name
  end

  def away_team_name
    plays_as == "away" ? team_of_interest.name : opponent_name
  end

  private

  def set_match_status
    scheduled_at.present? ? self.status = :scheduled : self.status = :created
  end
end