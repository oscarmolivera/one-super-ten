class CreateLandings < ActiveRecord::Migration[8.0]
  def change
    create_table :landings do |t|
      t.string :title
      t.text :description
      t.boolean :published
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
