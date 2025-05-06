class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.string :title, null: false
      t.text :description
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.date :spent_on, null: false

      t.string :expense_type, null: false
      t.string :payment_method
      t.string :reference_code

      t.references :expensable, polymorphic: true, index: true

      t.timestamps
    end
  end
end