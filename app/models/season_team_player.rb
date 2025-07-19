class SeasonTeamPlayer < ApplicationRecord
  belongs_to :season_team
  belongs_to :player, optional: true
  belongs_to :external_player, optional: true

  validates :origin, presence: true

  validates :jersey_number, numericality: { only_integer: true }, allow_nil: true
  validates :position, presence: true, allow_blank: true

  enum :origin, {
    main_category: "main_category",
    below_category: "below_category",
    above_category: "above_category",
    external: "external" 
  }
end
