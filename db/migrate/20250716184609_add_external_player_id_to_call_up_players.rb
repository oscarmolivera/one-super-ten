class AddExternalPlayerIdToCallUpPlayers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :call_up_players, :player_id, true

    add_column :call_up_players, :external_player_id, :bigint
    add_index :call_up_players, :external_player_id
    add_foreign_key :call_up_players, :external_players
  end
end