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

ActiveRecord::Schema.define(version: 2021_09_21_153423) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.bigint "player_one_id"
    t.bigint "player_two_id"
    t.bigint "player_with_turn_id"
    t.string "moves", default: [], array: true
    t.integer "status", default: 0, null: false
    t.integer "result", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug", default: "", null: false
    t.index ["player_one_id"], name: "index_games_on_player_one_id"
    t.index ["player_two_id"], name: "index_games_on_player_two_id"
    t.index ["player_with_turn_id"], name: "index_games_on_player_with_turn_id"
    t.index ["slug"], name: "index_games_on_slug"
  end

  create_table "players", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "win_count", default: 0, null: false
    t.integer "draw_count", default: 0, null: false
    t.integer "loss_count", default: 0, null: false
    t.integer "total_games_count", default: 0, null: false
    t.boolean "guest", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_players_on_username", unique: true
  end

  add_foreign_key "games", "players", column: "player_one_id"
  add_foreign_key "games", "players", column: "player_two_id"
  add_foreign_key "games", "players", column: "player_with_turn_id"
end
