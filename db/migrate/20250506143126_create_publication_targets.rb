class CreatePublicationTargets < ActiveRecord::Migration[8.0]
  def change
    create_table :publication_targets do |t|
      t.references :publication, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean    :read, default: false
      t.timestamps
    end
  end
end
