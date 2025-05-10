class CreateMatchReports < ActiveRecord::Migration[8.0]
  def change
    create_table :match_reports do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true # referee, coach, or delegate

      t.string  :author_role         # "referee", "team_coach", "delegate"
      t.text    :general_observations
      t.text    :incidents
      t.text    :team_claims
      t.text    :final_notes

      t.datetime :reported_at

      t.timestamps
    end
  end
end
