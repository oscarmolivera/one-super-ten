class ExternalPlayer < ApplicationRecord
  acts_as_tenant(:tenant)
  belongs_to :tenant

  has_many :season_team_players, dependent: :nullify

  validates :first_name, :last_name, :position, :jersey_number, :date_of_birth, presence: true
  validates_uniqueness_of :document_number, allow_blank: true, case_sensitive: false
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def last_tournament
    SeasonTeam
      .joins(:season_team_players)
      .joins(:tournament)
      .where(season_team_players: { external_player_id: id })
      .order("season_team_players.created_at DESC")
      .limit(1)
      .pluck("tournaments.name")
      .first
  end
end