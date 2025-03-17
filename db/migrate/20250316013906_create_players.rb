class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :email
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end
    add_index :players, :email
  end
end
