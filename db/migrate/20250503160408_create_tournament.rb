class CreateTournament < ActiveRecord::Migration[8.0]
  def change
    create_table :tournaments do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.boolean :public, default: false
      t.integer :status, default: 0 # draft by default

      t.timestamps
    end
  end
end
