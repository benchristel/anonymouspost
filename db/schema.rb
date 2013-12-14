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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131214222005) do

  create_table "posts", :force => true do |t|
    t.string   "content",         :limit => 720
    t.string   "xash",            :limit => 64,                   :null => false
    t.integer  "timestamp",                                       :null => false
    t.float    "longitude",                                       :null => false
    t.float    "latitude",                                        :null => false
    t.integer  "vote_total",                     :default => 0,   :null => false
    t.float    "vote_multiplier",                :default => 1.0, :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "users", :force => true do |t|
    t.string  "key_hash",              :limit => 64, :null => false
    t.integer "posting_allowed_after"
  end

  create_table "votes", :force => true do |t|
    t.string   "xash",       :limit => 64, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "post_id"
    t.integer  "value"
  end

end
