class AddTournamentToMatchPerformances < ActiveRecord::Migration[8.0]
  def change
    # Add tournament_id column and foreign key
    add_reference :match_performances, :tournament, null: false, foreign_key: true

    # Check if index exists before creating
    unless index_exists?(:match_performances, :tournament_id, name: "index_match_performances_on_tournament_id")
      add_index :match_performances, :tournament_id, name: "index_match_performances_on_tournament_id"
    end
  end
end