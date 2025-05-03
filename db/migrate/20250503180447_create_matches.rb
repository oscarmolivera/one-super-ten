class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.references :tenant, null: false
      t.references :tournament, foreign_key: true
      t.integer :match_type, default: 0
      t.string :opponent_name
      t.string :location
      t.datetime :scheduled_at
      t.integer :home_score
      t.integer :away_score
      t.text :notes

      t.timestamps
    end
  end
end
