class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :school, foreign_key: true     # Optional, only if hosted internally
      t.references :tenant, null: false, foreign_key: true

      t.string  :title, null: false
      t.text    :description

      t.datetime :start_time
      t.datetime :end_time

      t.string  :location_name
      t.string  :location_address
      t.boolean :external_organizer, default: false
      t.string  :organizer_name    # Only filled if external_organizer = true

      t.references :coach, foreign_key: { to_table: :users }, null: true
      t.integer :event_type, default: 0    # enum: match, friendly, tournament
      t.integer :status, default: 0        # enum: draft, published, canceled

      t.boolean :allow_reinforcements, default: false
      t.boolean :is_public, default: false

      t.timestamps
    end
  end
end
