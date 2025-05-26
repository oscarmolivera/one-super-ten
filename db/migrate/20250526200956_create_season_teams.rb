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
  end
end