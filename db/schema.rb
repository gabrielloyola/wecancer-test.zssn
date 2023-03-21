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

ActiveRecord::Schema.define(version: 2023_03_20_152327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "infection_reports", force: :cascade do |t|
    t.bigint "reporter_id", null: false
    t.bigint "infected_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["infected_id"], name: "index_infection_reports_on_infected_id"
    t.index ["reporter_id", "infected_id"], name: "index_infection_reports_on_reporter_id_and_infected_id"
    t.index ["reporter_id"], name: "index_infection_reports_on_reporter_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.bigint "survivor_id", null: false
    t.bigint "item_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_inventory_items_on_item_id"
    t.index ["survivor_id"], name: "index_inventory_items_on_survivor_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.integer "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_items_on_name"
  end

  create_table "survivors", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "gender"
    t.float "last_lat"
    t.float "last_long"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "infected", default: false
  end

  add_foreign_key "infection_reports", "survivors", column: "infected_id"
  add_foreign_key "infection_reports", "survivors", column: "reporter_id"
  add_foreign_key "inventory_items", "items"
  add_foreign_key "inventory_items", "survivors"
end
