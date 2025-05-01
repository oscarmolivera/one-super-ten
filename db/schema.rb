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

ActiveRecord::Schema[8.0].define(version: 2025_04_30_233102) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assistant_assignments", force: :cascade do |t|
    t.bigint "coach_id", null: false
    t.bigint "assistant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assistant_id"], name: "index_assistant_assignments_on_assistant_id"
    t.index ["coach_id"], name: "index_assistant_assignments_on_coach_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "school_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_categories_on_school_id"
    t.index ["tenant_id"], name: "index_categories_on_tenant_id"
  end

  create_table "category_coaches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_coaches_on_category_id"
    t.index ["user_id"], name: "index_category_coaches_on_user_id"
  end

  create_table "category_players", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_players_on_category_id"
    t.index ["player_id", "category_id"], name: "index_category_players_on_player_id_and_category_id", unique: true
    t.index ["player_id"], name: "index_category_players_on_player_id"
  end

  create_table "coach_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "hire_date"
    t.decimal "salary", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_coach_profiles_on_user_id"
  end

  create_table "landings", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "published"
    t.bigint "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_landings_on_tenant_id"
  end

  create_table "player_schools", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "school_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id", "school_id"], name: "index_player_schools_on_player_id_and_school_id", unique: true
    t.index ["player_id"], name: "index_player_schools_on_player_id"
    t.index ["school_id"], name: "index_player_schools_on_school_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "email"
    t.bigint "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "full_name"
    t.date "date_of_birth"
    t.string "gender"
    t.string "nationality"
    t.string "document_number"
    t.string "profile_picture"
    t.string "dominant_side"
    t.string "position"
    t.text "address"
    t.boolean "is_active", default: true, null: false
    t.text "bio"
    t.text "notes"
    t.bigint "user_id"
    t.index ["category_id"], name: "index_players_on_category_id"
    t.index ["email"], name: "index_players_on_email"
    t.index ["tenant_id"], name: "index_players_on_tenant_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tenant_id"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
    t.index ["tenant_id"], name: "index_roles_on_tenant_id"
  end

  create_table "schools", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_schools_on_tenant_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.datetime "created_at", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key", "key_hash"], name: "index_solid_cache_entries_on_key_and_key_hash", unique: true
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_tenant_id"
    t.index ["parent_tenant_id"], name: "index_tenants_on_parent_tenant_id"
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
    t.string "first_name"
    t.string "last_name"
    t.integer "failed_attempts"
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "assistant_assignments", "users", column: "assistant_id"
  add_foreign_key "assistant_assignments", "users", column: "coach_id"
  add_foreign_key "categories", "schools"
  add_foreign_key "categories", "tenants"
  add_foreign_key "category_coaches", "categories"
  add_foreign_key "category_coaches", "users"
  add_foreign_key "category_players", "categories"
  add_foreign_key "category_players", "players"
  add_foreign_key "coach_profiles", "users"
  add_foreign_key "landings", "tenants"
  add_foreign_key "player_schools", "players"
  add_foreign_key "player_schools", "schools"
  add_foreign_key "players", "categories"
  add_foreign_key "players", "tenants"
  add_foreign_key "players", "users"
  add_foreign_key "roles", "tenants"
  add_foreign_key "schools", "tenants"
  add_foreign_key "tenants", "tenants", column: "parent_tenant_id"
  add_foreign_key "users", "tenants"
end
