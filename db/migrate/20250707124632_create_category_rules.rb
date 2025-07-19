class CreateCategoryRules < ActiveRecord::Migration[8.0]
  def change
    create_table :category_rules do |t|
      t.references :category, null: false, foreign_key: true
      t.string :key, null: false
      t.string :value, null: false

      t.timestamps
    end

    add_index :category_rules, [:category_id, :key], unique: true
  end
end
