class Match < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tournament
  belongs_to :stage, optional: true 
  belongs_to :team_of_interest, class_name: 'SeasonTeam'
  belongs_to :rival_season_team, class_name: 'SeasonTeam', optional: true
  belongs_to :rival, optional: true

  has_many :categories, through: :call_ups
  has_many :line_ups, dependent: :destroy
  has_many :match_reports, dependent: :destroy
  has_many :match_performances, dependent: :destroy
  
  has_one :call_up, dependent: :destroy

  accepts_nested_attributes_for :match_performances, allow_destroy: true

  before_validation :set_initial_status, on: :create
  #before_validation :set_match_status, on: :update

  after_save :update_standings, if: :saved_change_to_status?

  validates :match_type, :plays_as, presence: true

  enum :match_type, { friendly: 0, tournament: 1, practice: 2 }
  enum :plays_as, { home: 0, away: 1 }
  enum :location_type, {home_field: 0, away_field: 1, neutral: 2 }

  state_machine :status, initial: :created, namespace: :match do
      state :created, value: 0
      state :scheduled, value: 1
      state :played, value: 2
      state :cancelled, value: 3
      state :reschedule, value: 4
      state :postponed, value: 5

      event :schedule do
        transition :created => :scheduled, if: :scheduled_at_present?
      end

      event :play do
        transition :scheduled => :played
      end
  end

  scope :ordered_by_status_and_schedule, -> {
    sql = <<~SQL.squish
      CASE status
        WHEN #{state_machine.states[:created].value} THEN 0
        WHEN #{state_machine.states[:scheduled].value} THEN 1
        WHEN #{state_machine.states[:reschedule].value} THEN 2
        WHEN #{state_machine.states[:postponed].value} THEN 3
        WHEN #{state_machine.states[:played].value} THEN 4
        WHEN #{state_machine.states[:cancelled].value} THEN 5
        ELSE 6
      END ASC,
      CASE
        WHEN status = #{state_machine.states[:played].value} THEN scheduled_at
        ELSE NULL
      END DESC,
      COALESCE(scheduled_at, '9999-12-31') ASC
    SQL
    Rails.logger.debug "Generated SQL: #{sql}"  # Remove after testing
    order(Arel.sql(sql))
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

  def validate_state_change
    return unless status_event.present?

    case status_event.to_sym
    when :schedule
      unless can_schedule?
        errors.add(:status, "Cannot schedule: scheduled_at is required.")
      end
    when :play
      unless can_play?
        errors.add(:status, "Cannot play: match must be scheduled first.")
      end
    else
      errors.add(:status, "Invalid status event: #{status_event}")
    end
  end

  # Helper methods for guards (can expand for more states later)
  def can_schedule?
    scheduled_at.present? && status == 'created'
  end

  def can_play?
    status == 'scheduled'
  end

  private

  def set_initial_status
    return if persisted?

    if scheduled_at.present?
      schedule!
    end
  end

  def update_standings
    StandingCalculatorService.new(tournament, stage).calculate if status == :played
  end

  def scheduled_at_present?
    scheduled_at.present?
  end
end