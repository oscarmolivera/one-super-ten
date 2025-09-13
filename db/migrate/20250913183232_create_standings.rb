class CreateStandings < ActiveRecord::Migration[8.0]
  def change
    create_table :standings do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true
      t.references :stage, null: true, foreign_key: true  # Optional, for phase-specific standings (e.g., group stage)
      t.string :standable_type, null: false  # Polymorphic: 'SeasonTeam' or 'Rival'
      t.bigint :standable_id, null: false
      t.integer :position, default: 0  # Ranking (1 = top)
      t.integer :points, default: 0
      t.integer :played, default: 0  # Matches played
      t.integer :wins, default: 0
      t.integer :draws, default: 0
      t.integer :losses, default: 0
      t.integer :goals_for, default: 0
      t.integer :goals_against, default: 0
      t.integer :goal_difference, default: 0  # Computed as goals_for - goals_against
      t.text :notes  # Optional admin notes (e.g., tiebreakers)

      t.timestamps
    end

    # Indexes for performance and uniqueness
    add_index :standings, [:tenant_id, :tournament_id, :stage_id]
    add_index :standings, [:standable_type, :standable_id]
    add_index :standings, [:tournament_id, :stage_id, :standable_type, :standable_id], unique: true, name: 'index_standings_unique_per_scope'
  end
end