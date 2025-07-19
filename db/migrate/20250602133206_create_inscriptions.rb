class CreateInscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :inscriptions do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :season_team, foreign_key: true

      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.text :notes
      t.timestamps
    end

    add_index :inscriptions, [:tournament_id, :category_id], unique: true
  end
end