class CreateCallUps < ActiveRecord::Migration[8.0]
  def change
    create_table :call_ups do |t|
      t.references :tenant, null: false
      t.references :category, null: false
      t.references :match, foreign_key: true
      t.string :name
      t.integer :status, default: 0
      t.datetime :call_up_date

      t.timestamps
    end
  end
end
