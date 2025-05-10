class CreateCallUpPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :call_up_players do |t|
      t.references :call_up, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :attendance, default: 0

      t.timestamps
    end
  end
end
