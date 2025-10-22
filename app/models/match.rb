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

  after_save :update_standings, if: :should_update_standings?
  around_save :handle_status_change_around_save

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
    # Rails.logger.debug "Generated SQL: #{sql}" # Remove after testing
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

  def handle_status_change_around_save
    unless @status_handled
      @status_handled = true
      handle_status_change
    end
    yield
  ensure
    @status_handled = false
  end

  def handle_status_change
    Rails.logger.debug "Handling status change for Match ID #{id || 'new record'} at #{Time.now.to_f}"
    if status_event.present?
      case status_event.to_sym
      when :cancel
        cancel_match if can_cancel?
      when :postpone
        postpone_match if can_postpone?
      when :play
        play_match if can_play?
      end
      return
    end
    # Handle scheduling/rescheduling
    if match_created? && scheduled_at_present? && scheduled_at_future?
      if new_record? || !scheduled_at_was.present?
        success = schedule_match
        Rails.logger.debug " schedule_match result: #{success}"
      end
    elsif (match_scheduled? || match_postponed?) && scheduled_at_changed? && scheduled_at_future?
      success = reschedule_match
      Rails.logger.debug " reschedule_match result: #{success}"
    end
  end

  def should_update_standings?
    match_played? && (saved_change_to_status? || saved_change_to_team_score? || saved_change_to_rival_score?)
  end

  def update_standings
    season_team = team_of_interest
    current_stage = season_team.current_stage
    return unless current_stage

    current_phase_value = Stage.phases[current_stage.phase] || 0
    if [0, 1].include?(current_phase_value)
      StandingCalculatorService.new(tournament, stage).calculate
    end
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