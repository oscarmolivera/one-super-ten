class CreateSolidCacheEntries < ActiveRecord::Migration[8.0]
  def change
    return if table_exists?(:solid_cache_entries)

    create_table :solid_cache_entries do |t|
      t.string   :key,        null: false
      t.string   :namespace
      t.binary   :value
      t.string   :compressor
      t.string   :coders
      t.datetime :expires_at
      t.string   :version

      t.timestamps
    end

    add_index :solid_cache_entries, [:namespace, :key], unique: true
    add_index :solid_cache_entries, :expires_at
  end
end

