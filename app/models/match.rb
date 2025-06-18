class Match < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tournament, optional: true

  belongs_to :home_team, class_name: 'SeasonTeam'
  belongs_to :away_team, class_name: 'SeasonTeam'
  
  has_many :call_ups, dependent: :destroy
  has_many :categories, through: :call_ups
  has_many :line_ups, dependent: :destroy
  has_many :match_reports, dependent: :destroy
  has_many :match_performances, dependent: :destroy

  enum :match_type, { friendly: 0, tournament: 1 }

  validates :location, presence: true

  scope :for_team, ->(team_id) { where('home_team_id = ? OR away_team_id = ?', team_id, team_id) }

  scope :for_category, ->(category_id, tournament_id: nil) do
    teams = SeasonTeam.where(category_id: category_id)
    teams = teams.where(tournament_id: tournament_id) if tournament_id.present?
    team_ids = teams.pluck(:id)
  
    where(home_team_id: team_ids).or(where(away_team_id: team_ids))
  end
end