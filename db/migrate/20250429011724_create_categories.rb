class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :school, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
