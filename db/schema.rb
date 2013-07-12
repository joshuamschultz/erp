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

ActiveRecord::Schema.define(:version => 20130712090951) do

  create_table "master_types", :force => true do |t|
    t.string   "type_name"
    t.string   "type_description"
    t.string   "type_category"
    t.boolean  "type_active"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "material_elements", :force => true do |t|
    t.integer  "material_id"
    t.string   "element_symbol"
    t.string   "element_name"
    t.string   "element_low_range"
    t.string   "element_high_range"
    t.boolean  "element_active"
    t.integer  "element_created_id"
    t.integer  "element_updated_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "material_elements", ["material_id"], :name => "index_material_elements_on_material_id"

  create_table "materials", :force => true do |t|
    t.string   "material_short_name"
    t.string   "material_description"
    t.text     "material_notes"
    t.integer  "material_created_id"
    t.integer  "material_updated_id"
    t.boolean  "material_active"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "owners", :force => true do |t|
    t.string   "owner_identifier"
    t.string   "owner_description"
    t.integer  "owner_commission_type_id"
    t.decimal  "owner_commission_amount",  :precision => 10, :scale => 0
    t.integer  "owner_created_id"
    t.integer  "owner_updated_id"
    t.boolean  "owner_active"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  create_table "process_types", :force => true do |t|
    t.string   "process_short_name"
    t.string   "process_description"
    t.text     "process_notes"
    t.boolean  "process_active"
    t.integer  "process_created_id"
    t.integer  "process_updated_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "test_items", :force => true do |t|
    t.integer  "test_package_id"
    t.string   "item_name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "test_items", ["test_package_id"], :name => "index_test_items_on_test_package_id"

  create_table "test_packages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "name",                   :default => "",   :null => false
    t.string   "gender",                 :default => ""
    t.text     "address"
    t.string   "city",                   :default => ""
    t.string   "state",                  :default => ""
    t.string   "country",                :default => ""
    t.string   "telephone_no"
    t.string   "mobile_no"
    t.string   "fax"
    t.boolean  "active",                 :default => true
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
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "vendor_qualities", :force => true do |t|
    t.string   "quality_name"
    t.string   "quality_description"
    t.text     "quality_notes"
    t.boolean  "quality_active"
    t.integer  "quality_created_id"
    t.integer  "quality_updated_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

end
