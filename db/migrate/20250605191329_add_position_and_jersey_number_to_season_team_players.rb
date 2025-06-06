class AddPositionAndJerseyNumberToSeasonTeamPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :season_team_players, :position, :string
    add_column :season_team_players, :jersey_number, :integer
  end
end
