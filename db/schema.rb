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

ActiveRecord::Schema[8.0].define(version: 2025_07_20_010900) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "code", null: false
    t.string "mac", null: false
    t.integer "mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hotspot_profiles", force: :cascade do |t|
    t.bigint "router_id", null: false
    t.string "name", null: false
    t.string "rate"
    t.jsonb "raw_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["router_id"], name: "index_hotspot_profiles_on_router_id"
  end

  create_table "login_counters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count"
  end

  create_table "routers", force: :cascade do |t|
    t.string "name", null: false
    t.string "host_name", null: false
    t.string "username", null: false
    t.string "password", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "raw_data", default: {}, null: false
    t.index ["user_id"], name: "index_routers_on_user_id"
  end

  create_table "station_documents", force: :cascade do |t|
    t.bigint "station_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["station_id"], name: "index_station_documents_on_station_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name", null: false
    t.string "prefix", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "router_id", null: false
    t.index ["prefix"], name: "index_stations_on_prefix", unique: true
    t.index ["router_id"], name: "index_stations_on_router_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vouchers", force: :cascade do |t|
    t.string "code", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.bigint "station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_collected", default: false
    t.index ["code"], name: "index_vouchers_on_code", unique: true
    t.index ["station_id"], name: "index_vouchers_on_station_id"
  end

  add_foreign_key "hotspot_profiles", "routers"
  add_foreign_key "routers", "users"
  add_foreign_key "station_documents", "stations"
  add_foreign_key "stations", "routers"
  add_foreign_key "vouchers", "stations"
end
