class MatchPerformance < ApplicationRecord
  belongs_to :match
  belongs_to :player

  validates :goals, :minutes_played, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end