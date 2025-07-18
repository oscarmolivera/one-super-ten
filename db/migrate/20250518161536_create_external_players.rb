class CreateExternalPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :external_players do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :document_number
      t.date :date_of_birth
      t.string :gender
      t.string :position
      t.string :jersey_number
      t.text :notes
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
