class PlayerProfile < ApplicationRecord
  belongs_to :player

  enum :status, { active: 0, suspended: 1, injured: 2 }
end