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

ActiveRecord::Schema[8.0].define(version: 2025_05_28_013149) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assistant_assignments", force: :cascade do |t|
    t.bigint "coach_id", null: false
    t.bigint "assistant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assistant_id"], name: "index_assistant_assignments_on_assistant_id"
    t.index ["coach_id"], name: "index_assistant_assignments_on_coach_id"
  end

  create_table "call_up_players", force: :cascade do |t|
    t.bigint "call_up_id", null: false
    t.bigint "player_id", null: false
    t.integer "attendance", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_up_id"], name: "index_call_up_players_on_call_up_id"
    t.index ["player_id"], name: "index_call_up_players_on_player_id"
  end

  create_table "call_ups", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "category_id", null: false
    t.bigint "match_id"
    t.string "name"
    t.integer "status", default: 0
    t.datetime "call_up_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_call_ups_on_category_id"
    t.index ["match_id"], name: "index_call_ups_on_match_id"
    t.index ["tenant_id"], name: "index_call_ups_on_tenant_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "school_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
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

  create_table "category_team_assistants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_team_assistants_on_category_id"
    t.index ["user_id", "category_id"], name: "index_category_team_assistants_on_user_id_and_category_id", unique: true
    t.index ["user_id"], name: "index_category_team_assistants_on_user_id"
  end

  create_table "coach_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "hire_date"
    t.decimal "salary", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_coach_profiles_on_user_id"
  end

  create_table "cups", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_id", null: false
    t.index ["school_id"], name: "index_cups_on_school_id"
    t.index ["tenant_id"], name: "index_cups_on_tenant_id"
  end

  create_table "event_participations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_event_participations_on_category_id"
    t.index ["event_id"], name: "index_event_participations_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "school_id"
    t.bigint "tenant_id", null: false
    t.string "title", null: false
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "location_name"
    t.string "location_address"
    t.boolean "external_organizer", default: false
    t.string "organizer_name"
    t.bigint "coach_id"
    t.integer "event_type", default: 0
    t.integer "status", default: 0
    t.boolean "allow_reinforcements", default: false
    t.boolean "is_public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_events_on_coach_id"
    t.index ["school_id"], name: "index_events_on_school_id"
    t.index ["tenant_id"], name: "index_events_on_tenant_id"
  end

  create_table "exonerations", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "player_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_exonerations_on_player_id"
    t.index ["tenant_id"], name: "index_exonerations_on_tenant_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "author_id", null: false
    t.string "title", null: false
    t.text "description"
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.date "spent_on", null: false
    t.string "expense_type", null: false
    t.string "payment_method"
    t.string "reference_code"
    t.string "expensable_type"
    t.bigint "expensable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_expenses_on_author_id"
    t.index ["expensable_type", "expensable_id"], name: "index_expenses_on_expensable"
    t.index ["tenant_id"], name: "index_expenses_on_tenant_id"
  end

  create_table "guardians", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "player_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "gender"
    t.string "relationship"
    t.string "address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_guardians_on_player_id"
    t.index ["tenant_id"], name: "index_guardians_on_tenant_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "source_type"
    t.bigint "source_id"
    t.string "title", null: false
    t.text "description"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "currency", default: "USD"
    t.string "tag"
    t.datetime "received_at", null: false
    t.string "income_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_type", "source_id"], name: "index_incomes_on_source"
    t.index ["tenant_id"], name: "index_incomes_on_tenant_id"
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

  create_table "line_ups", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "call_up_player_id", null: false
    t.integer "role", default: 0, null: false
    t.string "position", null: false
    t.integer "jersey_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_up_player_id"], name: "index_line_ups_on_call_up_player_id"
    t.index ["match_id", "call_up_player_id"], name: "index_line_ups_on_match_id_and_call_up_player_id", unique: true
    t.index ["match_id"], name: "index_line_ups_on_match_id"
  end

  create_table "match_performances", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "player_id", null: false
    t.integer "goals", default: 0
    t.integer "minutes_played", default: 0
    t.integer "assists", default: 0
    t.integer "yellow_cards", default: 0
    t.integer "red_cards", default: 0
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_performances_on_match_id"
    t.index ["player_id"], name: "index_match_performances_on_player_id"
  end

  create_table "match_reports", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "match_id", null: false
    t.bigint "user_id", null: false
    t.string "author_role"
    t.text "general_observations"
    t.text "incidents"
    t.text "team_claims"
    t.text "final_notes"
    t.datetime "reported_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_reports_on_match_id"
    t.index ["tenant_id"], name: "index_match_reports_on_tenant_id"
    t.index ["user_id"], name: "index_match_reports_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "tournament_id"
    t.integer "match_type", default: 0
    t.string "opponent_name"
    t.string "location"
    t.datetime "scheduled_at"
    t.integer "home_score"
    t.integer "away_score"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_matches_on_tenant_id"
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
  end

  create_table "player_profiles", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.integer "jersey_number"
    t.string "nickname"
    t.jsonb "social_links", default: {}
    t.text "internal_notes"
    t.integer "status", default: 0, null: false
    t.boolean "disciplinary_flag", default: false
    t.integer "skill_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_player_profiles_on_player_id", unique: true
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
    t.string "handle"
    t.boolean "public_profile"
    t.index ["email"], name: "index_players_on_email"
    t.index ["handle"], name: "index_players_on_handle", unique: true
    t.index ["tenant_id"], name: "index_players_on_tenant_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "publication_targets", force: :cascade do |t|
    t.bigint "publication_id", null: false
    t.bigint "user_id", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_publication_targets_on_publication_id"
    t.index ["user_id"], name: "index_publication_targets_on_user_id"
  end

  create_table "publications", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "author_id", null: false
    t.bigint "category_id"
    t.string "title", null: false
    t.text "body", null: false
    t.string "visibility", default: "all", null: false
    t.boolean "pinned", default: false
    t.datetime "published_at"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_publications_on_author_id"
    t.index ["category_id"], name: "index_publications_on_category_id"
    t.index ["tenant_id"], name: "index_publications_on_tenant_id"
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

  create_table "season_team_players", force: :cascade do |t|
    t.bigint "season_team_id", null: false
    t.bigint "player_id", null: false
    t.string "origin", null: false
    t.boolean "starter", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_season_team_players_on_player_id"
    t.index ["season_team_id", "player_id"], name: "index_season_team_players_on_season_team_id_and_player_id", unique: true
    t.index ["season_team_id"], name: "index_season_team_players_on_season_team_id"
  end

  create_table "season_teams", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "category_id", null: false
    t.bigint "tournament_id", null: false
    t.string "name", null: false
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_season_teams_on_category_id"
    t.index ["tenant_id"], name: "index_season_teams_on_tenant_id"
    t.index ["tournament_id"], name: "index_season_teams_on_tournament_id"
  end

  create_table "sites", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.string "name", null: false
    t.string "address"
    t.string "city"
    t.string "map_url"
    t.integer "capacity"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_sites_on_school_id"
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

  create_table "tournament_categories", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_tournament_categories_on_category_id"
    t.index ["tournament_id"], name: "index_tournament_categories_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.text "description"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.boolean "public", default: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cup_id", null: false
    t.index ["cup_id"], name: "index_tournaments_on_cup_id"
    t.index ["tenant_id"], name: "index_tournaments_on_tenant_id"
  end

  create_table "training_attendances", force: :cascade do |t|
    t.bigint "training_session_id", null: false
    t.bigint "player_id", null: false
    t.string "status", default: "present", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_training_attendances_on_player_id"
    t.index ["training_session_id", "player_id"], name: "index_training_attendance_on_session_and_player", unique: true
    t.index ["training_session_id"], name: "index_training_attendances_on_training_session_id"
  end

  create_table "training_sessions", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "coach_id", null: false
    t.bigint "site_id"
    t.datetime "scheduled_at", null: false
    t.integer "duration_minutes"
    t.text "objectives"
    t.text "activities"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_training_sessions_on_category_id"
    t.index ["coach_id"], name: "index_training_sessions_on_coach_id"
    t.index ["site_id"], name: "index_training_sessions_on_site_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assistant_assignments", "users", column: "assistant_id"
  add_foreign_key "assistant_assignments", "users", column: "coach_id"
  add_foreign_key "call_up_players", "call_ups"
  add_foreign_key "call_up_players", "players"
  add_foreign_key "call_ups", "matches"
  add_foreign_key "categories", "schools"
  add_foreign_key "categories", "tenants"
  add_foreign_key "category_coaches", "categories"
  add_foreign_key "category_coaches", "users"
  add_foreign_key "category_players", "categories"
  add_foreign_key "category_players", "players"
  add_foreign_key "category_team_assistants", "categories"
  add_foreign_key "category_team_assistants", "users"
  add_foreign_key "coach_profiles", "users"
  add_foreign_key "cups", "schools"
  add_foreign_key "cups", "tenants"
  add_foreign_key "event_participations", "categories"
  add_foreign_key "event_participations", "events"
  add_foreign_key "events", "schools"
  add_foreign_key "events", "tenants"
  add_foreign_key "events", "users", column: "coach_id"
  add_foreign_key "exonerations", "players"
  add_foreign_key "exonerations", "tenants"
  add_foreign_key "expenses", "tenants"
  add_foreign_key "expenses", "users", column: "author_id"
  add_foreign_key "guardians", "players"
  add_foreign_key "guardians", "tenants"
  add_foreign_key "incomes", "tenants"
  add_foreign_key "landings", "tenants"
  add_foreign_key "line_ups", "call_up_players"
  add_foreign_key "line_ups", "matches"
  add_foreign_key "match_performances", "matches"
  add_foreign_key "match_performances", "players"
  add_foreign_key "match_reports", "matches"
  add_foreign_key "match_reports", "tenants"
  add_foreign_key "match_reports", "users"
  add_foreign_key "matches", "tournaments"
  add_foreign_key "player_profiles", "players"
  add_foreign_key "player_schools", "players"
  add_foreign_key "player_schools", "schools"
  add_foreign_key "players", "tenants"
  add_foreign_key "players", "users"
  add_foreign_key "publication_targets", "publications"
  add_foreign_key "publication_targets", "users"
  add_foreign_key "publications", "categories"
  add_foreign_key "publications", "tenants"
  add_foreign_key "publications", "users", column: "author_id"
  add_foreign_key "roles", "tenants"
  add_foreign_key "schools", "tenants"
  add_foreign_key "season_team_players", "players"
  add_foreign_key "season_team_players", "season_teams"
  add_foreign_key "season_teams", "categories"
  add_foreign_key "season_teams", "tenants"
  add_foreign_key "season_teams", "tournaments"
  add_foreign_key "sites", "schools"
  add_foreign_key "tenants", "tenants", column: "parent_tenant_id"
  add_foreign_key "tournament_categories", "categories"
  add_foreign_key "tournament_categories", "tournaments"
  add_foreign_key "tournaments", "cups"
  add_foreign_key "tournaments", "tenants"
  add_foreign_key "training_attendances", "players"
  add_foreign_key "training_attendances", "training_sessions"
  add_foreign_key "training_sessions", "categories"
  add_foreign_key "training_sessions", "sites"
  add_foreign_key "training_sessions", "users", column: "coach_id"
  add_foreign_key "users", "tenants"
end
