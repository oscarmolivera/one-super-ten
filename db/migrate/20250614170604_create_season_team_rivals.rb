class CreateSeasonTeamRivals < ActiveRecord::Migration[8.0]
  def change
    create_table :season_team_rivals do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :season_team, null: false, foreign_key: true
      t.references :rival, null: false, foreign_key: true

      t.timestamps
    end
  end
end
