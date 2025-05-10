class MatchPerformance < ApplicationRecord
  belongs_to :match, touch: true
  belongs_to :player, touch: true

  validates :goals, :minutes_played, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end