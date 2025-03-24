# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_24_212106) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "landings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "published"
    t.bigint "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_landings_on_tenant_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "email"
    t.bigint "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_players_on_email"
    t.index ["tenant_id"], name: "index_players_on_tenant_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.string "key", null: false
    t.string "namespace"
    t.binary "value"
    t.string "compressor"
    t.string "coders"
    t.datetime "expires_at"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_cache_entries_on_expires_at"
    t.index ["namespace", "key"], name: "index_solid_cache_entries_on_namespace_and_key", unique: true
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tenant_id"
    t.index ["tenant_id"], name: "index_tenants_on_tenant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tenant_id", null: false
    t.integer "role", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  add_foreign_key "landings", "tenants"
  add_foreign_key "players", "tenants"
  add_foreign_key "tenants", "tenants"
  add_foreign_key "users", "tenants"
end
