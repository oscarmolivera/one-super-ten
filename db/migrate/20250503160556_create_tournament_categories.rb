class CreateTournamentCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :tournament_categories do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
