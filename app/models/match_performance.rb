class MatchPerformance < ApplicationRecord
  acts_as_tenant :tenant
  
  belongs_to :tournament
  belongs_to :match, touch: true
  belongs_to :performer, polymorphic: true # Can be Player or ExternalPlayer

  validates :goals, :minutes_played, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_tournament, on: :create

  private

  def set_tournament
    self.tournament = match.tournament if match
  end
end