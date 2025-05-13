class CreatePlayerProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :player_profiles do |t|
      t.references :player, null: false, foreign_key: true, index: { unique: true }

      t.integer  :jersey_number
      t.string   :nickname
      t.jsonb    :social_links, default: {}
      t.text     :internal_notes
      t.integer  :status, default: 0, null: false 
      t.boolean  :disciplinary_flag, default: false
      t.integer  :skill_rating

      t.timestamps
    end
  end
end
