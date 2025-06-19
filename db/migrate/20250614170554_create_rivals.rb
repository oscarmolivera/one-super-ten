class CreateRivals < ActiveRecord::Migration[8.0]
  def change
    create_table :rivals do |t|
      t.references :tenant, null: true, foreign_key: true
      t.string :name
      t.string :location
      t.boolean :active

      t.timestamps
    end
  end
end
