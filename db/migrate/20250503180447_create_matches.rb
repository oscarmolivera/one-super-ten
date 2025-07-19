class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true

      t.references :team_of_interest, null: false, foreign_key: { to_table: :season_teams }
      t.references :rival_season_team, foreign_key: { to_table: :season_teams }
      t.references :rival, foreign_key: { to_table: :rivals }

      t.integer :plays_as, null: false, default: 0       # enum: home / away
      t.integer :match_type, null: false, default: 1     # enum: friendly / tournament / practice

      t.string :location, null: false
      t.integer :location_type, null: false, default: 0  # enum: :home, :away, :neutral
      t.integer :status, default: 0  # enum: :scheduled, :played, :cancelled
      t.datetime :scheduled_at
      t.integer :team_score
      t.integer :rival_score
      t.text :notes

      t.timestamps
    end
  end
end