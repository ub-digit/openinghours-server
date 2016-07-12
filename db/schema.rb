# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160707131912) do

  create_table "libraries", force: :cascade do |t|
    t.string   "name_sv"
    t.string   "name_en"
    t.string   "sigel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "opening_hours", force: :cascade do |t|
    t.integer  "day_of_week_index"
    t.integer  "rule_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "closed"
    t.time     "opening_time"
    t.time     "closing_time"
  end

  create_table "rules", force: :cascade do |t|
    t.integer  "library_id",     null: false
    t.date     "startdate"
    t.date     "enddate"
    t.string   "ruletype"
    t.string   "name_sv"
    t.string   "name_en"
    t.text     "description_sv"
    t.text     "description_en"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
