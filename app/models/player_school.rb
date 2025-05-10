class PlayerSchool < ApplicationRecord
  belongs_to :player
  belongs_to :school

  validates :player_id, uniqueness: { scope: :school_id }
  
  # Active flag: true = currently enrolled, false = was but left
  attribute :active, :boolean, default: true
end