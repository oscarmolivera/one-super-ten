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

  # Scopes para helpers (sin tenant_id: filtra via season_team)
  scope :for_season_team, ->(season_team_id) { where(season_team_id: season_team_id) }
  scope :same_category, -> { where(origin: :main_category) }
  scope :other_category, -> { where(origin: [:below_category, :above_category]) }
  scope :external, -> { where(origin: :external) }

  # Callback: Auto-set origin (usa player.categories via schema)
  after_validation :set_origin_if_blank, on: [:create, :update]

  private

  def set_origin_if_blank
    return if origin.present?

    if external_player_id.present?
      self.origin = :external
    elsif player_id.present? && season_team.present?
      player_category_id = player.category_players.first&.category_id
      if player_category_id == season_team.category_id
        self.origin = :main_category
      else
        # Asume IDs numéricos para below/above (ajusta si usas sub_name)
        self.origin = player_category_id < season_team.category_id ? :below_category : :above_category
      end
    end
  end
end