class CreateMatchPerformances < ActiveRecord::Migration[8.0]
  def change
    create_table :match_performances do |t|
      t.references :match, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :goals, default: 0
      t.integer :minutes_played, default: 0
      t.integer :assists, default: 0
      t.integer :yellow_cards, default: 0
      t.integer :red_cards, default: 0
      t.text :notes

      t.timestamps
    end
  end
end
