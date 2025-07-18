class CreateStages < ActiveRecord::Migration[8.0]
  def change
    create_table :stages do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :season_team, null: false, foreign_key: true
      t.string :name
      t.integer :stage_type
      t.integer :order

      t.timestamps
    end
  end
end
