class AddIndexToSeasonTeams < ActiveRecord::Migration[8.0]
  def change
    add_index :season_teams, [:category_id, :tournament_id], unique: true
  end
end
