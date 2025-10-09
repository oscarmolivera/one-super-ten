class AddActiveToSeasonTeamRivals < ActiveRecord::Migration[8.0]
  def change
    add_column :season_team_rivals, :active, :boolean, default: true, null: false
    add_index :season_team_rivals, [:season_team_id, :rival_id, :active], unique: true, name: "index_season_team_rivals_on_team_rival_active_unique"
  end
end