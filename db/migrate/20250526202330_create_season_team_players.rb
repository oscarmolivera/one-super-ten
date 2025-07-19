class CreateSeasonTeamPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :season_team_players do |t|
      t.references :season_team, null: false, foreign_key: true
      t.references :player, null: true, foreign_key: true
      t.references :external_player, null: true, foreign_key: true
      t.string :origin, null: false # :main_category, :below_category, :above_category, :external
      t.bigint :category_id, null: true
      t.boolean :starter, default: false
      t.string :jersey_number, null: true
      t.string :position, null: true      

      t.timestamps
    end
    add_index :season_team_players, [:season_team_id, :player_id], unique: true
  end
end