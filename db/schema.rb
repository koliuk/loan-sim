# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_07_214100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interest_periods", force: :cascade do |t|
    t.integer "loan_id", null: false
    t.decimal "interest", precision: 8, scale: 2, null: false
  end

  create_table "loans", force: :cascade do |t|
    t.integer "simulation_id", null: false
    t.decimal "amount", precision: 11, scale: 2, null: false
    t.string "currency", null: false
    t.integer "period", default: 12, null: false
  end

  create_table "simulations", force: :cascade do |t|
    t.string "name", limit: 256, null: false
    t.integer "loan_id"
  end

end
