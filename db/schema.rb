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

ActiveRecord::Schema.define(:version => 20120622122254) do

  create_table "contacts", :force => true do |t|
    t.string   "address"
    t.string   "postal_code"
    t.string   "category"
    t.string   "country"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "infos"
    t.boolean  "is_active",       :default => true
    t.boolean  "is_ceres_member", :default => false
    t.string   "company"
    t.string   "position"
    t.string   "telphone"
    t.string   "fax"
    t.string   "cell"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "english"
    t.string   "french"
    t.string   "chinese"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "emails", :force => true do |t|
    t.string   "address"
    t.integer  "contact_id"
    t.integer  "has_bounced", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

end
