class CreateCoachProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :coach_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.date :hire_date
      t.decimal :salary, precision: 10, scale: 2

      t.timestamps
    end
  end
end
