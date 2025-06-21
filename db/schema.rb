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

ActiveRecord::Schema[8.0].define(version: 2025_06_20_121712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "code", null: false
    t.string "mac", null: false
    t.integer "mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stations", force: :cascade do |t|
    t.string "name", null: false
    t.string "prefix", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prefix"], name: "index_stations_on_prefix", unique: true
  end

  create_table "vouchers", force: :cascade do |t|
    t.string "code", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.bigint "station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_vouchers_on_code", unique: true
    t.index ["station_id"], name: "index_vouchers_on_station_id"
  end

  add_foreign_key "vouchers", "stations"
end
