class CreateGuardians < ActiveRecord::Migration[8.0]
  def change
    create_table :guardians do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :gender
      t.string :relationship
      t.string :address
      t.text :notes

      t.timestamps
    end
  end
end
