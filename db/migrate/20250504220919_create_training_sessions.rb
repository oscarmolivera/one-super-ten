class CreateTrainingSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :training_sessions do |t|
      t.references :category, null: false, foreign_key: true
      t.references :coach, null: false, foreign_key: { to_table: :users }
      t.references :site, foreign_key: true # optional, define your Site model
      t.datetime :scheduled_at, null: false
      t.integer :duration_minutes
      t.text :objectives
      t.text :activities # structured JSON could go here if desired
      t.text :notes

      t.timestamps
    end
  end
end
