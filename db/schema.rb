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

ActiveRecord::Schema.define(version: 2019_04_07_200815) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "accomplishments", force: :cascade do |t|
    t.bigint "team_id"
    t.integer "number"
    t.date "date"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_accomplishments_on_game_id"
    t.index ["team_id"], name: "index_accomplishments_on_team_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.integer "home_team_score"
    t.integer "away_team_score"
    t.string "mlb_game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.date "start_date"
    t.date "end_date"
    t.boolean "privated", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.index ["token"], name: "index_leagues_on_token", unique: true
    t.index ["user_id"], name: "index_leagues_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "league_id"
    t.bigint "user_id"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_memberships_on_league_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "ownerships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "league_id"
    t.bigint "team_id"
    t.boolean "active", default: true
    t.boolean "paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_ownerships_on_league_id"
    t.index ["team_id"], name: "index_ownerships_on_team_id"
    t.index ["user_id"], name: "index_ownerships_on_user_id"
  end

  create_table "task_records", id: false, force: :cascade do |t|
    t.string "version", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "mlb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "winners", force: :cascade do |t|
    t.bigint "league_id"
    t.bigint "user_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed", default: false
    t.bigint "accomplishment_id"
    t.integer "tiebreak"
    t.index ["accomplishment_id"], name: "index_winners_on_accomplishment_id"
    t.index ["league_id"], name: "index_winners_on_league_id"
    t.index ["user_id"], name: "index_winners_on_user_id"
  end

  add_foreign_key "accomplishments", "games"
  add_foreign_key "accomplishments", "teams"
  add_foreign_key "leagues", "users"
  add_foreign_key "memberships", "leagues"
  add_foreign_key "memberships", "users"
  add_foreign_key "ownerships", "leagues"
  add_foreign_key "ownerships", "teams"
  add_foreign_key "ownerships", "users"
  add_foreign_key "winners", "accomplishments"
  add_foreign_key "winners", "leagues"
  add_foreign_key "winners", "users"
end
