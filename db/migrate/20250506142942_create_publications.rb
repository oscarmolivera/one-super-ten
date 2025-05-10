class CreatePublications < ActiveRecord::Migration[8.0]
  def change
    create_table :publications do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :category, foreign_key: true
      t.string     :title, null: false
      t.text       :body, null: false
      t.string     :visibility, null: false, default: 'all'
      t.boolean    :pinned, default: false
      t.datetime   :published_at
      t.datetime   :expires_at
      t.timestamps
    end
  end
end
