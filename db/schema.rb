# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170601140439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "plperl"
  enable_extension "plperlu"
  enable_extension "plpython3u"
  enable_extension "plpythonu"
  enable_extension "adminpack"
  enable_extension "chkpass"
  enable_extension "dblink"
  enable_extension "file_fdw"
  enable_extension "fuzzystrmatch"
  enable_extension "intarray"
  enable_extension "pg_buffercache"
  enable_extension "pg_freespacemap"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "pgrowlocks"
  enable_extension "pgstattuple"
  enable_extension "sslinfo"
  enable_extension "tablefunc"
  enable_extension "pg_stat_statements"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "account_id"
    t.string "display_name"
    t.boolean "is_active", default: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: "2017-05-26 06:23:45", null: false
    t.index ["account_id"], name: "index_accounts_on_account_id"
  end

  create_table "captcha_whitelists", id: :serial, force: :cascade do |t|
    t.string "created_by", null: false
    t.string "ip"
    t.datetime "created_at", default: "2017-05-26 06:23:45", null: false
    t.datetime "updated_at", default: "2017-05-26 06:23:45", null: false
    t.index ["ip"], name: "index_captcha_whitelists_on_ip"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "failed_logins", id: :serial, force: :cascade do |t|
    t.string "ip"
    t.integer "failures", default: 0
    t.datetime "created_at", default: "2017-05-26 06:23:45", null: false
    t.datetime "updated_at", default: "2017-05-26 06:23:45", null: false
    t.index ["ip"], name: "index_failed_logins_on_ip"
  end

  create_table "insurance_application_filled_forms", force: :cascade do |t|
    t.integer "user_id"
    t.bigint "insurance_application_form_id"
    t.integer "status"
    t.string "xml"
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.index ["insurance_application_form_id"], name: "ins_app_form_id_idx"
  end

  create_table "insurance_application_forms", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.integer "session_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["session_id"], name: "index_oauth_access_tokens_on_session_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "key", null: false
    t.datetime "last_seen", null: false
    t.jsonb "login_from", default: "{}"
    t.boolean "remember_me", default: false
    t.index ["key"], name: "index_sessions_on_key", unique: true
  end

  create_table "user_application_logs", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "application_id", null: false
    t.integer "sign_in_count"
    t.string "last_sign_in_ip"
    t.string "current_sign_in_ip"
    t.datetime "last_sign_in_at"
    t.datetime "current_sign_in_at"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["application_id"], name: "index_user_application_logs_on_application_id"
    t.index ["user_id"], name: "index_user_application_logs_on_user_id"
  end

  create_table "user_applications", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "application_id", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["application_id"], name: "index_user_applications_on_application_id"
    t.index ["user_id"], name: "index_user_applications_on_user_id"
  end

  create_table "user_browser_stats", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "application_id", null: false
    t.integer "browser_id", null: false
    t.string "ip_address"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["application_id"], name: "index_user_browser_stats_on_application_id"
    t.index ["browser_id"], name: "index_user_browser_stats_on_browser_id"
    t.index ["user_id"], name: "index_user_browser_stats_on_user_id"
  end

  create_table "user_browsers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.string "full_version"
    t.string "operating_system"
    t.string "user_agent_text"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "linkedin_title"
    t.string "linkedin_company"
    t.string "crypted_password"
    t.string "salt"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.string "provider"
    t.string "uid"
    t.string "username"
    t.string "account_id"
    t.string "created_by"
    t.boolean "auto_created"
    t.text "notes"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.integer "modified_by"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "insurance_application_filled_forms", "insurance_application_forms"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id", on_delete: :cascade
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id", on_delete: :cascade
end
