class CreateExternalPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :external_players do |t|
      t.string :first_name
      t.string :last_name
      t.string :document_number
      t.date :date_of_birth
      t.string :gender
      t.string :position
      t.string :jersey_number
      t.text :notes

      t.timestamps
    end
  end
end
