class UpdateMatchPerformancesProperties < ActiveRecord::Migration[8.0]
  def change
    remove_reference :match_performances, :player, index: true, foreign_key: true
    add_reference :match_performances, :performer, polymorphic: true, index: true
    rename_column :match_performances, :goals, :goals_scored
    rename_column :match_performances, :minutes_played, :minute_of_event
    add_reference :match_performances, :tenant, null: false, foreign_key: true, index: true
    add_index :match_performances, [:tenant_id, :performer_type, :performer_id], name: "index_match_performances_on_tenant_and_performer"
    add_index :match_performances, [:tenant_id, :tournament_id], name: "index_match_performances_on_tenant_and_tournament"
  end
end
