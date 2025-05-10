class CreateIncomes < ActiveRecord::Migration[8.0]
  def change
    create_table :incomes do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :source, polymorphic: true # E.g., Invoice, ProductSale, Sponsor, etc.

      t.string :title, null: false
      t.text :description
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :currency, default: "USD"
      t.string :tag

      t.datetime :received_at, null: false
      t.string :income_type, null: false # enum: monthly_payment, product_sale, sponsor, investment, etc.

      t.timestamps
    end
  end
end
