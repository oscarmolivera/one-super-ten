class AddPhaseToStages < ActiveRecord::Migration[8.0]
  def change
    add_column :stages, :phase, :integer
  end
end
