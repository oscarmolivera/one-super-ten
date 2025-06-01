class AddCupToTournaments < ActiveRecord::Migration[8.0]
  def change
    add_reference :tournaments, :cup, null: false, foreign_key: true
  end
end
