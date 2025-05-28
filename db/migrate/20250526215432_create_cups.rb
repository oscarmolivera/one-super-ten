class CreateCups < ActiveRecord::Migration[8.0]
  def change
    create_table :cups do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
