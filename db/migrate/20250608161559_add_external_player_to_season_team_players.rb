class AddExternalPlayerToSeasonTeamPlayers < ActiveRecord::Migration[8.0]
  def change
    add_reference :season_team_players, :external_player, foreign_key: true
  end
end
