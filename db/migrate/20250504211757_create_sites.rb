class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites do |t|
      t.references :school, null: false, foreign_key: true 
      t.string :name, null: false
      t.string :address
      t.string :city
      t.string :map_url
      t.integer :capacity
      t.text :description

      t.timestamps
    end
  end
end
