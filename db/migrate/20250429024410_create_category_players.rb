class CreateCategoryPlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :category_players do |t|
      t.references :player, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :category_players, [:player_id, :category_id], unique: true
  end
end