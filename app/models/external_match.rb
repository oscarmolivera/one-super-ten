class ExternalMatch < ApplicationRecord
  belongs_to :tenant
  belongs_to :stage, optional: true
  belongs_to :home_rival, class_name: "Rival"
  belongs_to :away_rival, class_name: "Rival"

  validates :home_rival_id, :away_rival_id, presence: true
  validate :different_rivals

  enum :status, { pending: 0, completed: 1 }

  after_save :update_standings

  private

  def different_rivals
    errors.add(:base, "Home and away rivals must be different") if home_rival_id == away_rival_id
  end

  def update_standings
    return unless status == "completed" && stage.present?

    StandingCalculatorService.new(Tournament.find(tournament_id), Stage.find(stage_id)).calculate
  end
end