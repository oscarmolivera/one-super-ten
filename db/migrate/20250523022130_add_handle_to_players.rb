class AddHandleToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :handle, :string
    add_index :players, :handle, unique: true
  end
end
