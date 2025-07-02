class AddStageToMatches < ActiveRecord::Migration[8.0]
  def change
    add_reference :matches, :stage, null: false, foreign_key: true
  end
end
