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

ActiveRecord::Schema[7.1].define(version: 2024_05_30_052405) do
  create_table "time_reports", force: :cascade do |t|
    t.integer "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timesheets", force: :cascade do |t|
    t.date "date"
    t.decimal "hours_worked"
    t.integer "employee_id"
    t.string "job_group"
    t.integer "time_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["time_report_id"], name: "index_timesheets_on_time_report_id"
  end

  add_foreign_key "timesheets", "time_reports"
end
