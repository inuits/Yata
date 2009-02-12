# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090211100649) do

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
  end

  create_table "customers", :force => true do |t|
    t.string   "shortname",  :limit => 10
    t.string   "name",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours", :force => true do |t|
    t.integer  "timesheet_id"
    t.integer  "day",          :null => false
    t.string   "detail"
    t.integer  "normal"
    t.integer  "travel"
    t.integer  "rate2"
    t.integer  "rate3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", :force => true do |t|
    t.integer  "authuser_id",                   :null => false
    t.integer  "customer_id",                   :null => false
    t.integer  "year",        :default => 2009, :null => false
    t.integer  "month",       :default => 2,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
