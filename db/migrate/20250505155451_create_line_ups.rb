class CreateLineUps < ActiveRecord::Migration[8.0]
  def change
    create_table :line_ups do |t|
      t.references :match, null: false, foreign_key: true
      t.references :call_up_player, null: false, foreign_key: true
      t.integer :role, default: 0, null: false 
      t.string :position, null: false
      t.integer :jersey_number
      t.timestamps
    end

    add_index :line_ups, [:match_id, :call_up_player_id], unique: true
  end
end
