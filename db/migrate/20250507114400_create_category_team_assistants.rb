class CreateCategoryTeamAssistants < ActiveRecord::Migration[8.0]
  def change
    create_table :category_team_assistants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end

    add_index :category_team_assistants, [:user_id, :category_id], unique: true
  end
end
