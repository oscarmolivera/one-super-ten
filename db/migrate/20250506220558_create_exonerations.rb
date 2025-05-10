class CreateExonerations < ActiveRecord::Migration[8.0]
  def change
    create_table :exonerations do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :reason

      t.timestamps
    end
  end
end