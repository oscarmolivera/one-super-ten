class CreateExternalMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :external_matches do |t|
      t.belongs_to :tenant, null: false, foreign_key: true
      t.belongs_to :tournament, null: false, foreign_key: true
      t.belongs_to :stage, foreign_key: true  # Optional, if staged
      t.belongs_to :home_rival, null: false, foreign_key: { to_table: :rivals }
      t.belongs_to :away_rival, null: false, foreign_key: { to_table: :rivals }
      t.integer :home_score, default: 0
      t.integer :away_score, default: 0
      t.date :match_date
      t.time :match_time
      t.integer :status, default: 0  # e.g., 0: pending, 1: completed
      t.text :notes

      t.timestamps
    end
  end
end