class AddPlayerCategoryIdToCallUpPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :call_up_players, :player_category_id, :bigint
    add_index :call_up_players, :player_category_id
  end
end
