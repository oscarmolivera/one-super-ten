class AddPropertiesToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :first_name, :string, null: false
    add_column :players, :last_name, :string, null: false
    add_column :players, :full_name, :string, null: true
    add_column :players, :date_of_birth, :date
    add_column :players, :gender, :string
    add_column :players, :nationality, :string
    add_column :players, :document_number, :string, null: true
    add_column :players, :profile_picture, :string, null: true
    add_column :players, :dominant_side, :string, null: true
    add_column :players, :position, :string, null: true
    add_column :players, :address, :text, null: true
    add_column :players, :is_active, :boolean, default: true, null: false
    add_column :players, :bio, :text
    add_column :players, :notes, :text

    add_reference :players, :user, foreign_key: true, index: true, null: true
  end
end