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

  after_save :update_standings, if: :saved_change_to_status?
  before_save :handle_reschedule, if: -> { !new_record? && match_scheduled? }

  validates :tenant, :tournament, :team_of_interest, presence: true

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
      transition :created => :scheduled, if: [:scheduled_at_present?, :scheduled_at_future?]
    end

    event :play do
      transition :scheduled => :played
      transition :reschedule => :played
    end

    event :cancel do
      transition :created => :cancelled
      transition :scheduled => :cancelled
      transition :reschedule => :cancelled
      transition :postponed => :cancelled
    end

    event :reschedule do
      transition :scheduled => :reschedule
      transition :postponed => :reschedule
    end

    event :postpone do
      transition :scheduled => :postponed
      transition :reschedule => :postponed
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
    Rails.logger.debug "Validating state change for Match ID #{id || 'new record'} with status_event: '#{status_event}'"
    return if status_event.blank?

    case status_event.to_sym
    when :postpone
      errors.add(:status, "Cannot postpone: must be scheduled or rescheduled.") unless can_postpone?
    when :cancel
      errors.add(:status, "Cannot cancel: invalid from current state.") unless can_cancel?
    else
      errors.add(:status, "Invalid status event: #{status_event}")
    end
  end

  def can_schedule?
    scheduled_at.present? && match_created?
  end

  def can_play?
    (match_scheduled? || match_reschedule? || match_postponed?) && scheduled_at_past?
  end

  def can_cancel?
    match_created? || match_scheduled? || match_reschedule? || match_postponed?
  end

  def can_reschedule?
    (match_scheduled? || match_postponed?) && scheduled_at_changed? && scheduled_at_future?
  end

  def can_postpone?
    match_scheduled? || match_reschedule?
  end

  private

  def set_initial_status  
    return if persisted? || !match_created?

    if scheduled_at.present?
      if schedule_match
        Rails.logger.info "Successfully scheduled new match"
      else
        errors.add(:scheduled_at, "must be in the future to schedule") if !scheduled_at_future?
      end
    end
  end

  def handle_reschedule
    if will_save_change_to_scheduled_at? && scheduled_at_future?
      if reschedule_match
        Rails.logger.info "Auto-rescheduled Match #{id} to #{scheduled_at}"
      else
        errors.add(:scheduled_at, "must be a future change to reschedule")
      end
    end
  end

  def update_standings
    StandingCalculatorService.new(tournament, stage).calculate if status == :played
  end

  def scheduled_at_present?
    scheduled_at.present?
  end

  def scheduled_at_changed?
    previous_scheduled_at = changes['scheduled_at']&.first
    scheduled_at != previous_scheduled_at
  end

  def scheduled_at_future?
    scheduled_at > DateTime.current
  end

  def scheduled_at_past?
    scheduled_at <= DateTime.current
  end
end