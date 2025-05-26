class SeasonTeamPlayer < ApplicationRecord
  belongs_to :season_team
  belongs_to :player

  enum :origin, {
    main_category: "main_category",
    below_category: "below_category",
    above_category: "above_category",
    external: "external" 
  }

  validates :origin, presence: true
end