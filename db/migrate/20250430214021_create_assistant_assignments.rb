class CreateAssistantAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :assistant_assignments do |t|
      t.references :coach, null: false, foreign_key: { to_table: :users }
      t.references :assistant, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
