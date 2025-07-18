class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :tenant, null: false, foreign_key: true
    add_column :users, :first_name, :string, null: true
    add_column :users, :last_name, :string, null: true
    add_column :users, :failed_attempts, :integer
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime
  end
end
