class CreateCups < ActiveRecord::Migration[8.0]
  def change
    create_table :cups do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :location

      t.timestamps
    end
    add_reference :tournaments, :cup, null: false, foreign_key: true
    add_reference :cups, :school, null: false, foreign_key: true
  end
end
