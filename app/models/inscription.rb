class Inscription < ApplicationRecord
  belongs_to :tournament
  belongs_to :category
  belongs_to :season_team, optional: true
  belongs_to :creator, class_name: 'User'
  
  validates :tournament_id, uniqueness: { scope: :category_id }
  
  accepts_nested_attributes_for :season_team
  
  after_create :create_season_team_for_category

  private

  def create_season_team_for_category
    self.season_team ||= SeasonTeam.create!(
      tournament: tournament,
      category: category,
      tenant: tournament.cup.school.tenant,
      name: "#{category.name} - #{tournament.name}",
      created_by_id: creator.id
    )
    save!
  end
end