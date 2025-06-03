class AddCreatedByToSeasonTeams < ActiveRecord::Migration[8.0]
  def change
    add_reference :season_teams, :created_by, foreign_key: { to_table: :users }, index: true
  end
end