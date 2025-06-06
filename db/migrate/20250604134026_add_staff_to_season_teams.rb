class AddStaffToSeasonTeams < ActiveRecord::Migration[8.0]
  def change
    add_reference :season_teams, :coach, foreign_key: { to_table: :users }
    add_reference :season_teams, :assistant_coach, foreign_key: { to_table: :users }
    add_reference :season_teams, :team_assistant, foreign_key: { to_table: :users }
  end
end