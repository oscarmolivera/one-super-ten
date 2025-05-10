class CreatePlayerSchools < ActiveRecord::Migration[8.0]
  def change
    create_table :player_schools do |t|
      t.references :player, null: false, foreign_key: true
      t.references :school, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
    add_index :player_schools, [:player_id, :school_id], unique: true
  end
end
