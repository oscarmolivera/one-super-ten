class AddPublicProfileToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :public_profile, :boolean
  end
end
