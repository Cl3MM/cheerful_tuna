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

ActiveRecord::Schema.define(:version => 20121015163129) do

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
    t.string   "phone"
    t.string   "fax"
    t.string   "cell"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "website"
    t.integer  "user_id"
  end

  add_index "contacts", ["company", "country", "first_name", "last_name", "address"], :name => "index_senateurs", :unique => true, :length => {"company"=>nil, "country"=>35, "first_name"=>30, "last_name"=>30, "address"=>200}
  add_index "contacts", ["company"], :name => "index_contacts_on_company"
  add_index "contacts", ["country"], :name => "index_contacts_on_country"
  add_index "contacts", ["user_id"], :name => "user_id"

  create_table "contacts_members", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "member_id"
  end

  add_index "contacts_members", ["contact_id", "member_id"], :name => "index_contacts_members_on_contact_id_and_member_id"

  create_table "countries", :force => true do |t|
    t.string   "english"
    t.string   "french"
    t.string   "chinese"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "email_listings", :force => true do |t|
    t.string   "name",                       :null => false
    t.text     "countries"
    t.text     "categories"
    t.integer  "per_line",   :default => 70
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "email_listings", ["name"], :name => "index_email_listings_on_name", :unique => true

  create_table "emails", :force => true do |t|
    t.string   "address"
    t.integer  "contact_id"
    t.integer  "has_bounced", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "emails", ["address"], :name => "index_emails_on_address", :unique => true
  add_index "emails", ["contact_id"], :name => "index_emails_on_contact_id"

  create_table "members", :force => true do |t|
    t.string   "company"
    t.string   "address"
    t.string   "city"
    t.string   "postal_code"
    t.string   "country"
    t.string   "category"
    t.string   "vat_number"
    t.string   "billing_address"
    t.string   "billing_city"
    t.string   "billing_postal_code"
    t.string   "billing_country"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "membership_file"
    t.string   "logo_file"
    t.date     "start_date"
    t.string   "email",                  :default => "", :null => false
    t.string   "user_name",              :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "web_profile_url"
  end

  add_index "members", ["company", "country", "address"], :name => "index_members_on_company_and_country_and_address", :unique => true
  add_index "members", ["company"], :name => "index_members_on_company"
  add_index "members", ["confirmation_token"], :name => "index_members_on_confirmation_token", :unique => true
  add_index "members", ["email"], :name => "index_members_on_email", :unique => true
  add_index "members", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true
  add_index "members", ["unlock_token"], :name => "index_members_on_unlock_token", :unique => true
  add_index "members", ["user_name"], :name => "index_members_on_user_name", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "role",                   :default => "user"
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "username",               :default => "",     :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.integer  "reverted_from"
    t.string   "tag"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
