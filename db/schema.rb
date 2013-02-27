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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120921103740) do

  create_table "authusers", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "fullname"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "admin"
    t.decimal  "min_hours",                               :precision => 3, :scale => 2, :default => 7.0
    t.decimal  "max_hours",                               :precision => 3, :scale => 2, :default => 9.0
    t.decimal  "max_travel_hours",                        :precision => 3, :scale => 2, :default => 3.0
  end

  create_table "customers", :force => true do |t|
    t.string   "shortname",  :limit => 10
    t.string   "name",                     :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "hours", :force => true do |t|
    t.integer  "timesheet_id"
    t.integer  "day",                                        :null => false
    t.string   "detail"
    t.decimal  "normal",       :precision => 4, :scale => 2
    t.decimal  "travel",       :precision => 4, :scale => 2
    t.decimal  "rate2",        :precision => 4, :scale => 2
    t.decimal  "rate3",        :precision => 4, :scale => 2
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "hours", ["timesheet_id"], :name => "fk_hours_timesheet_id"

  create_table "projects", :force => true do |t|
    t.integer  "customer_id",                 :null => false
    t.string   "shortname",     :limit => 10
    t.string   "name",                        :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.boolean  "fixed_price"
    t.boolean  "billable"
    t.integer  "total_price"
    t.integer  "price_per_day"
    t.integer  "duration"
    t.date     "end_date"
  end

  create_table "timesheets", :force => true do |t|
    t.integer  "authuser_id",                                  :null => false
    t.integer  "customer_id",                                  :null => false
    t.integer  "year",                       :default => 2013, :null => false
    t.integer  "month",                      :default => 2,    :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "remarks",     :limit => 250
    t.integer  "project_id"
  end

  add_index "timesheets", ["authuser_id"], :name => "fk_timesheets_authuser_id"
  add_index "timesheets", ["customer_id"], :name => "fk_timesheets_customer_id"

  create_table "tips", :force => true do |t|
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
