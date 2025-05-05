class CreateTrainingAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :training_attendances do |t|
      t.references :training_session, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.string :status, default: "present", null: false
      t.text :notes

      t.timestamps
    end

    add_index :training_attendances, [:training_session_id, :player_id], unique: true, name: "index_training_attendance_on_session_and_player"
  end
end
