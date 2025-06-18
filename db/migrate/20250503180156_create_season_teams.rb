class CreateSeasonTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :season_teams do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :season_teams, [:category_id, :tournament_id], unique: true
    add_reference :season_teams, :created_by, foreign_key: { to_table: :users }, index: true
    add_reference :season_teams, :coach, foreign_key: { to_table: :users }
    add_reference :season_teams, :assistant_coach, foreign_key: { to_table: :users }
    add_reference :season_teams, :team_assistant, foreign_key: { to_table: :users }
  end
end
