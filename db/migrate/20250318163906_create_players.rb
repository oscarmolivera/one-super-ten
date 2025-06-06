class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :email
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :full_name, null: true
      t.date :date_of_birth
      t.string :gender
      t.string :nationality
      t.string :document_number, null: true
      t.string :profile_picture, null: true
      t.string :dominant_side, null: true
      t.string :jersey_number, null: true
      t.string :position, null: true
      t.string :handle
      t.text :address, null: true
      t.text :bio
      t.text :notes
      t.boolean :is_active, default: true, null: false
      t.boolean :public_profile
      t.references :tenant, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true, index: true
      t.timestamps
    end
    add_index(:players, :email)
    add_index(:players, :handle, unique: true)
  end
end
