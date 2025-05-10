class CreateEventParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :event_participations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
