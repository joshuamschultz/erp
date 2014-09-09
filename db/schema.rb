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

ActiveRecord::Schema.define(:version => 20140826184308) do

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "attachment_file_name"
    t.string   "attachment_file_size"
    t.string   "attachment_content_type"
    t.string   "attachment_revision_title"
    t.date     "attachment_revision_date"
    t.date     "attachment_effective_date"
    t.string   "attachment_name"
    t.string   "attachment_description"
    t.string   "attachment_document_type"
    t.integer  "attachment_document_type_id"
    t.text     "attachment_notes"
    t.boolean  "attachment_public",           :default => false
    t.boolean  "attachment_active",           :default => false
    t.string   "attachment_status"
    t.integer  "attachment_status_id"
    t.integer  "attachment_created_id"
    t.integer  "attachment_updated_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "capacity_plannings", :force => true do |t|
    t.string   "capacity_plan_name"
    t.string   "capacity_plan_description"
    t.text     "capacity_plan_notes"
    t.boolean  "capacity_plan_active"
    t.integer  "capacity_plan_created_id"
    t.integer  "capacity_plan_updated_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "cause_analyses", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "notes"
    t.boolean  "active"
    t.integer  "created_id"
    t.integer  "updated_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "check_codes", :force => true do |t|
    t.string   "counter"
    t.string   "counter_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "check_entries", :force => true do |t|
    t.string   "check_identifier"
    t.string   "check_code"
    t.boolean  "check_active"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "check_list_lines", :force => true do |t|
    t.integer  "checklist_id"
    t.integer  "master_type_id"
    t.boolean  "check_list_status"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "check_list_lines", ["checklist_id"], :name => "index_check_list_lines_on_checklist_id"
  add_index "check_list_lines", ["master_type_id"], :name => "index_check_list_lines_on_master_type_id"

  create_table "checklists", :force => true do |t|
    t.integer  "quality_lot_id"
    t.string   "checklist_status"
    t.integer  "po_line_id"
    t.integer  "customer_quality_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "checklists", ["customer_quality_id"], :name => "index_checklists_on_customer_quality_id"
  add_index "checklists", ["po_line_id"], :name => "index_checklists_on_po_line_id"
  add_index "checklists", ["quality_lot_id"], :name => "index_checklists_on_quality_lot_id"

  create_table "comments", :force => true do |t|
    t.string   "comment"
    t.string   "comment_type"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "comment_active"
    t.integer  "comment_created_id"
    t.integer  "comment_updated_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "commodities", :force => true do |t|
    t.boolean  "commodity_active"
    t.integer  "commodity_created_id"
    t.integer  "commodity_updated_id"
    t.string   "commodity_identifier"
    t.string   "commodity_description"
    t.text     "commodity_notes"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "company_infos", :force => true do |t|
    t.string   "company_name"
    t.text     "company_address1"
    t.text     "company_address2"
    t.string   "company_phone1"
    t.string   "company_phone2"
    t.string   "company_mobile"
    t.string   "company_fax"
    t.string   "company_website"
    t.string   "company_slogan"
    t.boolean  "company_active"
    t.integer  "company_created_id"
    t.integer  "company_updated_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.string   "contact_type"
    t.string   "contact_title"
    t.string   "contact_description"
    t.text     "contact_address_1"
    t.text     "contact_address_2"
    t.string   "contact_city"
    t.string   "contact_state"
    t.string   "contact_country"
    t.string   "contact_zipcode"
    t.string   "contact_telephone"
    t.string   "contact_fax"
    t.string   "contact_email"
    t.string   "contact_website"
    t.text     "contact_notes"
    t.boolean  "contact_active"
    t.integer  "contact_created_id"
    t.integer  "contact_updated_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "control_plans", :force => true do |t|
    t.string   "plan_name"
    t.string   "plan_description"
    t.text     "plan_notes"
    t.boolean  "plan_active"
    t.integer  "plan_created_id"
    t.integer  "plan_updated_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "customer_feedbacks", :force => true do |t|
    t.integer  "organization_id"
    t.string   "title"
    t.text     "feedback"
    t.integer  "quality_action_id"
    t.integer  "user_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "customer_feedback_type_id"
  end

  add_index "customer_feedbacks", ["organization_id"], :name => "index_customer_feedbacks_on_organization_id"
  add_index "customer_feedbacks", ["user_id"], :name => "index_customer_feedbacks_on_user_id"

  create_table "customer_qualities", :force => true do |t|
    t.string   "quality_name"
    t.string   "quality_description"
    t.text     "quality_notes"
    t.boolean  "quality_active"
    t.integer  "quality_created_id"
    t.integer  "quality_updated_id"
    t.boolean  "quality_supplier_a"
    t.boolean  "quality_supplier_b"
    t.boolean  "quality_floor_plan"
    t.boolean  "quality_form"
    t.boolean  "quality_packaging"
    t.boolean  "quality_psw"
    t.boolean  "quality_control_plan"
    t.boolean  "quality_fmea"
    t.boolean  "quality_process_flow"
    t.boolean  "quality_gauge"
    t.boolean  "quality_study"
    t.boolean  "quality_dimensional_cofc"
    t.boolean  "quality_material_cofc"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "customer_quality_levels", :force => true do |t|
    t.integer  "customer_quality_id"
    t.integer  "master_type_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "customer_quality_levels", ["customer_quality_id"], :name => "index_customer_quality_levels_on_customer_quality_id"
  add_index "customer_quality_levels", ["master_type_id"], :name => "index_customer_quality_levels_on_master_type_id"

  create_table "customer_quote_lines", :force => true do |t|
    t.integer  "customer_quote_id"
    t.integer  "item_id"
    t.integer  "item_revision_id"
    t.integer  "item_alt_name_id"
    t.integer  "quote_vendor_id"
    t.string   "customer_quote_line_description"
    t.string   "customer_quote_line_identifier"
    t.integer  "customer_quote_line_quantity"
    t.decimal  "customer_quote_line_cost",         :precision => 25, :scale => 10, :default => 0.0
    t.string   "customer_quote_line_status"
    t.text     "customer_quote_line_notes"
    t.boolean  "customer_quote_line_active"
    t.integer  "customer_quote_line_created_id"
    t.integer  "customer_quote_line_updated_id"
    t.decimal  "customer_quote_line_tooling_cost", :precision => 25, :scale => 10, :default => 0.0
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.decimal  "customer_quote_line_total",        :precision => 25, :scale => 10, :default => 0.0
    t.string   "lead_time"
    t.string   "item_name_sub"
  end

  add_index "customer_quote_lines", ["customer_quote_id"], :name => "index_customer_quote_lines_on_customer_quote_id"
  add_index "customer_quote_lines", ["item_alt_name_id"], :name => "index_customer_quote_lines_on_item_alt_name_id"
  add_index "customer_quote_lines", ["item_id"], :name => "index_customer_quote_lines_on_item_id"
  add_index "customer_quote_lines", ["item_revision_id"], :name => "index_customer_quote_lines_on_item_revision_id"
  add_index "customer_quote_lines", ["quote_vendor_id"], :name => "index_customer_quote_lines_on_quote_vendor_id"

  create_table "customer_quotes", :force => true do |t|
    t.integer  "organization_id"
    t.string   "customer_quote_identifier"
    t.string   "customer_quote_description"
    t.string   "customer_quote_status"
    t.text     "customer_quote_notes"
    t.boolean  "customer_quote_active"
    t.integer  "customer_quote_created_id"
    t.integer  "customer_quote_updated_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "customer_quotes", ["organization_id"], :name => "index_customer_quotes_on_organization_id"

  create_table "deposit_checks", :force => true do |t|
    t.string   "status"
    t.integer  "payment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "receipt_id"
  end

  add_index "deposit_checks", ["payment_id"], :name => "index_deposit_checks_on_payment_id"

  create_table "dimensions", :force => true do |t|
    t.string   "dimension_identifier"
    t.string   "dimension_description"
    t.text     "dimension_notes"
    t.boolean  "dimension_active"
    t.integer  "dimension_created_id"
    t.integer  "dimension_updated_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "elements", :force => true do |t|
    t.string   "element_name"
    t.string   "element_symbol"
    t.text     "element_notes"
    t.integer  "element_created_id"
    t.integer  "element_updated_id"
    t.boolean  "element_active"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "fmea_types", :force => true do |t|
    t.string   "fmea_name"
    t.string   "fmea_description"
    t.text     "fmea_notes"
    t.boolean  "fmea_active"
    t.integer  "fmea_created_id"
    t.integer  "fmea_updated_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "gauges", :force => true do |t|
    t.integer  "organization_id"
    t.string   "gauge_tool_name"
    t.string   "gauge_tool_category"
    t.string   "gauge_tool_no"
    t.date     "gage_caliberation_last_at"
    t.date     "gage_caliberation_due_at"
    t.integer  "gage_caliberaion_period"
    t.boolean  "gauge_active"
    t.integer  "gauge_created_id"
    t.integer  "gauge_updated_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "gauges", ["organization_id"], :name => "index_gauges_on_organization_id"

  create_table "gl_accounts", :force => true do |t|
    t.integer  "gl_type_id"
    t.string   "gl_account_title"
    t.string   "gl_account_identifier"
    t.string   "gl_account_description"
    t.boolean  "gl_account_active"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.float    "gl_account_amount",      :default => 0.0
    t.boolean  "key_account",            :default => true
  end

  add_index "gl_accounts", ["gl_type_id"], :name => "index_gl_accounts_on_gl_type_id"

  create_table "gl_entries", :force => true do |t|
    t.string   "gl_entry_identifier"
    t.integer  "gl_account_id"
    t.string   "gl_entry_description"
    t.date     "gl_entry_date",                                        :default => '2014-01-07'
    t.decimal  "gl_entry_credit",      :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "gl_entry_debit",       :precision => 25, :scale => 10, :default => 0.0
    t.text     "gl_entry_notes"
    t.boolean  "gl_entry_active",                                      :default => true
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
  end

  add_index "gl_entries", ["gl_account_id"], :name => "index_gl_entries_on_gl_account_id"

  create_table "gl_types", :force => true do |t|
    t.string   "gl_name"
    t.string   "gl_side"
    t.string   "gl_report"
    t.string   "gl_identifier"
    t.string   "gl_description"
    t.boolean  "gl_active"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "group_organizations", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "group_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "group_organizations", ["group_id"], :name => "index_group_organizations_on_group_id"
  add_index "group_organizations", ["organization_id"], :name => "index_group_organizations_on_organization_id"

  create_table "groups", :force => true do |t|
    t.string   "group_name"
    t.string   "group_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "images", :force => true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "image_title"
    t.string   "image_description"
    t.text     "image_notes"
    t.string   "image_file_name"
    t.string   "image_file_size"
    t.string   "image_content_type"
    t.boolean  "image_public"
    t.boolean  "image_active"
    t.integer  "image_created_id"
    t.integer  "image_updated_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "item_alt_names", :force => true do |t|
    t.string   "item_alt_identifier"
    t.string   "item_alt_description"
    t.text     "item_alt_notes"
    t.boolean  "item_alt_active"
    t.integer  "item_alt_created_id"
    t.integer  "item_alt_updated_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "organization_id"
    t.integer  "item_id"
  end

  create_table "item_materials", :force => true do |t|
    t.integer  "item_revision_id"
    t.integer  "material_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "item_materials", ["item_revision_id"], :name => "index_item_materials_on_item_revision_id"
  add_index "item_materials", ["material_id"], :name => "index_item_materials_on_material_id"

  create_table "item_part_dimensions", :force => true do |t|
    t.integer  "item_revision_id"
    t.integer  "dimension_id"
    t.integer  "gauge_id"
    t.string   "item_part_letter"
    t.decimal  "item_part_dimension",     :precision => 15, :scale => 10, :default => 0.0
    t.decimal  "item_part_pos_tolerance", :precision => 15, :scale => 10, :default => 0.0
    t.decimal  "item_part_neg_tolerance", :precision => 15, :scale => 10, :default => 0.0
    t.boolean  "item_part_critical"
    t.text     "item_part_notes"
    t.boolean  "item_part_active"
    t.integer  "item_part_created_id"
    t.integer  "item_part_updated_id"
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
    t.boolean  "go_non_go",                                               :default => false
    t.string   "dimension_string"
  end

  add_index "item_part_dimensions", ["dimension_id"], :name => "index_item_part_dimensions_on_dimension_id"
  add_index "item_part_dimensions", ["gauge_id"], :name => "index_item_part_dimensions_on_gauge_id"
  add_index "item_part_dimensions", ["item_revision_id"], :name => "index_item_part_dimensions_on_item_revision_id"

  create_table "item_prints", :force => true do |t|
    t.integer  "item_revision_id"
    t.integer  "print_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "item_prints", ["item_revision_id"], :name => "index_item_prints_on_item_revision_id"
  add_index "item_prints", ["print_id"], :name => "index_item_prints_on_print_id"

  create_table "item_processes", :force => true do |t|
    t.integer  "item_revision_id"
    t.integer  "process_type_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "item_processes", ["item_revision_id"], :name => "index_item_processes_on_item_revision_id"
  add_index "item_processes", ["process_type_id"], :name => "index_item_processes_on_process_type_id"

  create_table "item_revisions", :force => true do |t|
    t.string   "item_revision_name"
    t.date     "item_revision_date"
    t.integer  "item_id"
    t.integer  "owner_id"
    t.integer  "organization_id"
    t.integer  "vendor_quality_id"
    t.integer  "customer_quality_id"
    t.string   "item_name"
    t.string   "item_description"
    t.text     "item_notes"
    t.decimal  "item_tooling",             :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "item_cost",                :precision => 25, :scale => 10, :default => 0.0
    t.integer  "item_revision_created_id"
    t.integer  "item_revision_updated_id"
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.integer  "print_id"
    t.integer  "material_id"
    t.boolean  "latest_revision"
    t.boolean  "item_revision_complete",                                   :default => false
    t.decimal  "item_sell",                :precision => 15, :scale => 10
  end

  add_index "item_revisions", ["customer_quality_id"], :name => "index_item_revisions_on_customer_quality_id"
  add_index "item_revisions", ["item_id"], :name => "index_item_revisions_on_item_id"
  add_index "item_revisions", ["organization_id"], :name => "index_item_revisions_on_organization_id"
  add_index "item_revisions", ["owner_id"], :name => "index_item_revisions_on_owner_id"
  add_index "item_revisions", ["vendor_quality_id"], :name => "index_item_revisions_on_vendor_quality_id"

  create_table "item_selected_names", :force => true do |t|
    t.integer  "item_revision_id"
    t.integer  "item_alt_name_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "item_selected_names", ["item_alt_name_id"], :name => "index_item_selected_names_on_item_alt_name_id"
  add_index "item_selected_names", ["item_revision_id"], :name => "index_item_selected_names_on_item_revision_id"

  create_table "item_specifications", :force => true do |t|
    t.integer  "item_revision_id"
    t.integer  "specification_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "item_specifications", ["item_revision_id"], :name => "index_item_specifications_on_item_revision_id"
  add_index "item_specifications", ["specification_id"], :name => "index_item_specifications_on_specification_id"

  create_table "items", :force => true do |t|
    t.string   "item_part_no"
    t.integer  "item_quantity_on_order"
    t.integer  "item_quantity_in_hand"
    t.boolean  "item_active"
    t.integer  "item_created_id"
    t.integer  "item_updated_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "logos", :force => true do |t|
    t.integer  "jointable_id"
    t.string   "jointable_type"
    t.string   "joint_title"
    t.string   "joint_description"
    t.text     "joint_notes"
    t.string   "joint_file_name"
    t.string   "joint_file_size"
    t.string   "joint_content_type"
    t.datetime "joint_updated_at"
    t.boolean  "joint_public"
    t.boolean  "joint_active"
    t.integer  "joint_created_id"
    t.integer  "joint_updated_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "master_types", :force => true do |t|
    t.string   "type_name"
    t.string   "type_description"
    t.string   "type_category"
    t.boolean  "type_active",      :default => true
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "type_value"
  end

  create_table "material_elements", :force => true do |t|
    t.integer  "material_id"
    t.integer  "element_id"
    t.string   "element_symbol"
    t.string   "element_name"
    t.decimal  "element_low_range",  :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "element_high_range", :precision => 25, :scale => 10, :default => 0.0
    t.boolean  "element_active",                                     :default => true
    t.integer  "element_created_id"
    t.integer  "element_updated_id"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
  end

  add_index "material_elements", ["material_id"], :name => "index_material_elements_on_material_id"

  create_table "materials", :force => true do |t|
    t.string   "material_short_name"
    t.string   "material_description"
    t.text     "material_notes"
    t.integer  "material_created_id"
    t.integer  "material_updated_id"
    t.boolean  "material_active",      :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "organization_processes", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "process_type_id"
    t.boolean  "org_process_active"
    t.integer  "org_process_created_id"
    t.integer  "org_process_updated_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "organization_processes", ["organization_id"], :name => "index_organization_processes_on_organization_id"
  add_index "organization_processes", ["process_type_id"], :name => "index_organization_processes_on_process_type_id"

  create_table "organizations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_type_id"
    t.integer  "territory_id"
    t.integer  "customer_quality_id"
    t.integer  "customer_contact_type_id"
    t.integer  "customer_max_quality_id"
    t.integer  "vendor_quality_id"
    t.date     "vendor_expiration_date"
    t.string   "organization_name"
    t.string   "organization_short_name"
    t.string   "organization_description"
    t.text     "organization_address_1"
    t.text     "organization_address_2"
    t.string   "organization_city"
    t.string   "organization_state"
    t.string   "organization_country"
    t.string   "organization_zipcode"
    t.string   "organization_telephone"
    t.string   "organization_fax"
    t.string   "organization_email"
    t.string   "organization_website"
    t.text     "organization_notes"
    t.boolean  "organization_active"
    t.integer  "organization_created_id"
    t.integer  "organization_updated_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "customer_min_quality_id"
    t.boolean  "organization_complete",    :default => false
  end

  add_index "organizations", ["customer_quality_id"], :name => "index_organizations_on_customer_quality_id"
  add_index "organizations", ["territory_id"], :name => "index_organizations_on_territory_id"
  add_index "organizations", ["user_id"], :name => "index_organizations_on_user_id"
  add_index "organizations", ["vendor_quality_id"], :name => "index_organizations_on_vendor_quality_id"

  create_table "owners", :force => true do |t|
    t.string   "owner_identifier"
    t.string   "owner_description"
    t.integer  "owner_commission_type_id"
    t.decimal  "owner_commission_amount",  :precision => 25, :scale => 10, :default => 0.0
    t.integer  "owner_created_id"
    t.integer  "owner_updated_id"
    t.boolean  "owner_active",                                             :default => true
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
  end

  create_table "packages", :force => true do |t|
    t.integer  "quality_lot_id"
    t.decimal  "part_size_length",             :precision => 10, :scale => 0
    t.decimal  "part_size_width",              :precision => 10, :scale => 0
    t.decimal  "part_size_height",             :precision => 10, :scale => 0
    t.decimal  "container_length",             :precision => 10, :scale => 0
    t.decimal  "container_width",              :precision => 10, :scale => 0
    t.decimal  "container_height",             :precision => 10, :scale => 0
    t.decimal  "pallet_length",                :precision => 10, :scale => 0
    t.decimal  "pallet_width",                 :precision => 10, :scale => 0
    t.decimal  "pallet_height",                :precision => 10, :scale => 0
    t.decimal  "load_shipped_length",          :precision => 10, :scale => 0
    t.decimal  "load_shipped_width",           :precision => 10, :scale => 0
    t.decimal  "load_shipped_height",          :precision => 10, :scale => 0
    t.decimal  "part_weight",                  :precision => 10, :scale => 0
    t.decimal  "dunnage_tare_Weight",          :precision => 10, :scale => 0
    t.decimal  "container_tare_weight",        :precision => 10, :scale => 0
    t.decimal  "pallet_tare_weight",           :precision => 10, :scale => 0
    t.decimal  "container_gross_inc_weight",   :precision => 10, :scale => 0
    t.decimal  "unit_load_gross",              :precision => 10, :scale => 0
    t.integer  "quantity_per_container"
    t.integer  "container_per_layer_pallet"
    t.integer  "layers_per_pallet"
    t.integer  "container_per_pallet"
    t.text     "package_comment"
    t.string   "part_content_type"
    t.integer  "part_file_size"
    t.datetime "part_updated_at"
    t.string   "part_file_name"
    t.string   "container_content_type"
    t.integer  "container_file_size"
    t.datetime "container_updated_at"
    t.string   "container_file_name"
    t.string   "dunnage_content_type"
    t.integer  "dunnage_file_size"
    t.datetime "dunnage_updated_at"
    t.string   "dunnage_file_name"
    t.string   "unit_load_content_type"
    t.integer  "unit_load_file_size"
    t.datetime "unit_load_updated_at"
    t.string   "unit_load_file_name"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.text     "dunnage_manufacturer"
    t.text     "container_color_manufacturer"
    t.text     "container_type_manufacturer"
    t.text     "cover_cap_manufacturer"
    t.text     "pallet_manufacturer"
    t.text     "strech_shrink_manufacturer"
    t.text     "banding_manufacturer"
    t.text     "other_manufacturer"
    t.text     "dunnage_material"
    t.text     "container_color_material"
    t.text     "container_type_material"
    t.text     "cover_cap_material"
    t.text     "pallet_material"
    t.text     "strech_shrink_material"
    t.text     "banding_material"
    t.text     "other_material"
    t.text     "dunnage_lead_time"
    t.text     "container_color_lead_time"
    t.text     "container_type_lead_time"
    t.text     "cover_cap_lead_time"
    t.text     "pallet_lead_time"
    t.text     "strech_shrink_lead_time"
    t.text     "banding_lead_time"
    t.text     "other_lead_time"
    t.text     "dunnage_ret_exp"
    t.text     "container_color_ret_exp"
    t.text     "container_type_ret_exp"
    t.text     "cover_cap_ret_exp"
    t.text     "pallet_ret_exp"
    t.text     "strech_shrink_ret_exp"
    t.text     "banding_ret_exp"
    t.text     "other_ret_exp"
    t.text     "dunnage_comment"
    t.text     "container_color_comment"
    t.text     "container_type_comment"
    t.text     "cover_cap_comment"
    t.text     "pallet_comment"
    t.text     "strech_shrink_comment"
    t.text     "banding_comment"
    t.text     "other_comment"
    t.decimal  "in_to_mm1",                    :precision => 10, :scale => 0
    t.decimal  "in_to_mm2",                    :precision => 10, :scale => 0
    t.decimal  "lbs_to_kg1",                   :precision => 10, :scale => 0
    t.decimal  "lbs_to_kg2",                   :precision => 10, :scale => 0
    t.string   "supplier_code"
  end

  create_table "payable_accounts", :force => true do |t|
    t.integer  "payable_id"
    t.integer  "gl_account_id"
    t.string   "payable_account_description"
    t.decimal  "payable_account_amount",      :precision => 25, :scale => 10, :default => 0.0
    t.integer  "payable_account_created_id"
    t.integer  "payable_account_updated_id"
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  add_index "payable_accounts", ["gl_account_id"], :name => "index_payable_accounts_on_gl_account_id"
  add_index "payable_accounts", ["payable_id"], :name => "index_payable_accounts_on_payable_id"

  create_table "payable_lines", :force => true do |t|
    t.integer  "payable_id"
    t.string   "payable_line_identifier"
    t.string   "payable_line_description"
    t.decimal  "payable_line_cost",        :precision => 25, :scale => 10, :default => 0.0
    t.text     "payable_line_notes"
    t.string   "payable_line_status"
    t.boolean  "payable_line_active"
    t.integer  "payable_line_created_id"
    t.integer  "payable_line_updated_id"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  add_index "payable_lines", ["payable_id"], :name => "index_payable_lines_on_payable_id"

  create_table "payable_po_shipments", :force => true do |t|
    t.integer  "po_shipment_id"
    t.integer  "payable_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "payable_po_shipments", ["payable_id"], :name => "index_payable_po_shipments_on_payable_id"
  add_index "payable_po_shipments", ["po_shipment_id"], :name => "index_payable_po_shipments_on_po_shipment_id"

  create_table "payable_shipments", :force => true do |t|
    t.integer  "payable_id"
    t.integer  "po_line_id"
    t.string   "payable_shipment_identifier"
    t.integer  "payable_shipment_count",                                      :default => 0
    t.decimal  "payable_shipment_cost",       :precision => 25, :scale => 10, :default => 0.0
    t.integer  "payable_shipment_created_id"
    t.integer  "payable_shipment_updated_id"
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  add_index "payable_shipments", ["payable_id"], :name => "index_payable_shipments_on_payable_id"
  add_index "payable_shipments", ["po_line_id"], :name => "index_payable_shipments_on_po_line_id"

  create_table "payables", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "po_header_id"
    t.integer  "payable_to_id"
    t.string   "payable_identifier"
    t.string   "payable_description"
    t.decimal  "payable_cost",         :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "payable_discount",     :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "payable_total",        :precision => 25, :scale => 10, :default => 0.0
    t.date     "payable_invoice_date"
    t.date     "payable_due_date"
    t.text     "payable_notes"
    t.string   "payable_status"
    t.boolean  "payable_active"
    t.integer  "payable_created_id"
    t.integer  "payable_updated_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.decimal  "payable_freight",      :precision => 25, :scale => 10, :default => 0.0
    t.string   "payable_invoice"
    t.integer  "gl_account_id"
  end

  add_index "payables", ["gl_account_id"], :name => "index_payables_on_gl_account_id"
  add_index "payables", ["organization_id"], :name => "index_payables_on_organization_id"
  add_index "payables", ["po_header_id"], :name => "index_payables_on_po_header_id"

  create_table "payment_lines", :force => true do |t|
    t.integer  "payment_id"
    t.integer  "payable_id"
    t.decimal  "payment_line_amount",     :precision => 25, :scale => 10, :default => 0.0
    t.integer  "payment_line_created_id"
    t.integer  "payment_line_updated_id"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  add_index "payment_lines", ["payable_id"], :name => "index_payment_lines_on_payable_id"
  add_index "payment_lines", ["payment_id"], :name => "index_payment_lines_on_payment_id"

  create_table "payments", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "payment_type_id"
    t.string   "payment_check_code"
    t.decimal  "payment_check_amount", :precision => 25, :scale => 10, :default => 0.0
    t.string   "payment_check_no"
    t.string   "payment_identifier"
    t.string   "payment_description"
    t.text     "payment_notes"
    t.string   "payment_status"
    t.boolean  "payment_active"
    t.integer  "payment_created_id"
    t.integer  "payment_updated_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.integer  "check_entry_id"
  end

  add_index "payments", ["check_entry_id"], :name => "index_payments_on_check_entry_id"
  add_index "payments", ["organization_id"], :name => "index_payments_on_organization_id"

  create_table "po_headers", :force => true do |t|
    t.integer  "po_type_id"
    t.integer  "organization_id"
    t.string   "po_identifier"
    t.string   "po_description"
    t.decimal  "po_total",        :precision => 25, :scale => 10, :default => 0.0
    t.string   "po_status"
    t.text     "po_notes"
    t.boolean  "po_active"
    t.integer  "po_created_id"
    t.integer  "po_updated_id"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "customer_id"
    t.integer  "po_bill_to_id"
    t.integer  "po_ship_to_id"
    t.string   "cusotmer_po"
    t.integer  "so_header_id"
  end

  add_index "po_headers", ["organization_id"], :name => "index_po_headers_on_organization_id"
  add_index "po_headers", ["so_header_id"], :name => "index_po_headers_on_so_header_id"

  create_table "po_lines", :force => true do |t|
    t.integer  "po_header_id"
    t.integer  "organization_id"
    t.integer  "so_line_id"
    t.integer  "vendor_quality_id"
    t.integer  "customer_quality_id"
    t.integer  "item_id"
    t.integer  "item_revision_id"
    t.integer  "item_selected_name_id"
    t.integer  "item_alt_name_id"
    t.string   "po_line_customer_po"
    t.decimal  "po_line_cost",          :precision => 25, :scale => 10, :default => 0.0
    t.integer  "po_line_quantity",                                      :default => 0
    t.decimal  "po_line_total",         :precision => 25, :scale => 10, :default => 0.0
    t.string   "po_line_status"
    t.text     "po_line_notes"
    t.boolean  "po_line_active"
    t.integer  "po_line_created_id"
    t.integer  "po_line_updated_id"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.integer  "po_line_shipped",                                       :default => 0
    t.integer  "alt_name_transfer_id"
    t.decimal  "po_line_sell",          :precision => 25, :scale => 10, :default => 0.0
  end

  add_index "po_lines", ["alt_name_transfer_id"], :name => "index_po_lines_on_alt_name_transfer_id"
  add_index "po_lines", ["customer_quality_id"], :name => "index_po_lines_on_customer_quality_id"
  add_index "po_lines", ["item_id"], :name => "index_po_lines_on_item_id"
  add_index "po_lines", ["item_revision_id"], :name => "index_po_lines_on_item_revision_id"
  add_index "po_lines", ["organization_id"], :name => "index_po_lines_on_organization_id"
  add_index "po_lines", ["po_header_id"], :name => "index_po_lines_on_po_header_id"
  add_index "po_lines", ["so_line_id"], :name => "index_po_lines_on_so_line_id"
  add_index "po_lines", ["vendor_quality_id"], :name => "index_po_lines_on_vendor_quality_id"

  create_table "po_shipments", :force => true do |t|
    t.integer  "po_line_id"
    t.integer  "po_shipped_count",                                       :default => 0
    t.decimal  "po_shipped_cost",        :precision => 25, :scale => 10, :default => 0.0
    t.string   "po_shipped_shelf"
    t.string   "po_shipped_unit"
    t.string   "po_shipped_status"
    t.integer  "po_shipment_created_id"
    t.integer  "po_shipment_updated_id"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
  end

  add_index "po_shipments", ["po_line_id"], :name => "index_po_shipments_on_po_line_id"

  create_table "ppaps", :force => true do |t|
    t.integer  "quality_lot_id"
    t.boolean  "initial_submission",         :default => false
    t.boolean  "re_submission",              :default => false
    t.boolean  "change_to_materials_used",   :default => false
    t.boolean  "revision_change",            :default => false
    t.boolean  "camo_pattern_new_to_part",   :default => false
    t.boolean  "tooling_replacement",        :default => false
    t.boolean  "process_change",             :default => false
    t.boolean  "Change_in_mfg_source",       :default => false
    t.boolean  "level1",                     :default => false
    t.boolean  "level2",                     :default => false
    t.boolean  "level3",                     :default => false
    t.boolean  "level4",                     :default => false
    t.boolean  "level5",                     :default => false
    t.boolean  "purchasing_agreement",       :default => false
    t.boolean  "first_article_parts",        :default => false
    t.boolean  "part_submission_warrant",    :default => false
    t.boolean  "fai_dimensional_inspection", :default => false
    t.boolean  "packaging_shipping",         :default => false
    t.boolean  "fai_material_test_result",   :default => false
    t.boolean  "component_review_meeting",   :default => false
    t.boolean  "guage_review",               :default => false
    t.boolean  "dfmea_desing",               :default => false
    t.boolean  "measurement_analysis",       :default => false
    t.boolean  "process_flow_diagram",       :default => false
    t.boolean  "process_capabilty_study",    :default => false
    t.boolean  "pfmea_analysis",             :default => false
    t.boolean  "production_run_rate",        :default => false
    t.boolean  "control_plan",               :default => false
    t.boolean  "appearance_report",          :default => false
    t.boolean  "Other",                      :default => false
    t.boolean  "result_meeting_yes",         :default => false
    t.boolean  "result_meeting_no",          :default => false
    t.integer  "past_hour"
    t.integer  "hour_run"
    t.integer  "date"
    t.integer  "commited_weekly_capacity"
    t.integer  "maximum_weekly_capacity"
    t.string   "lathe_cnc"
    t.text     "comment"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "ppaps", ["quality_lot_id"], :name => "index_ppaps_on_quality_lot_id"

  create_table "printing_screens", :force => true do |t|
    t.string   "status"
    t.integer  "payment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "printing_screens", ["payment_id"], :name => "index_printing_screens_on_payment_id"

  create_table "prints", :force => true do |t|
    t.boolean  "print_active"
    t.integer  "print_created_id"
    t.integer  "print_updated_id"
    t.string   "print_identifier"
    t.string   "print_description"
    t.text     "print_notes"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "process_flows", :force => true do |t|
    t.string   "process_identifier"
    t.string   "process_name"
    t.string   "process_description"
    t.text     "process_notes"
    t.boolean  "process_active"
    t.integer  "process_created_id"
    t.integer  "process_updated_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "process_types", :force => true do |t|
    t.string   "process_short_name"
    t.string   "process_description"
    t.text     "process_notes"
    t.boolean  "process_active",      :default => true
    t.integer  "process_created_id"
    t.integer  "process_updated_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "quality_action_numbers", :force => true do |t|
    t.integer  "next_action_no", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "quality_actions", :force => true do |t|
    t.integer  "quality_action_no"
    t.integer  "ic_action_id"
    t.integer  "organization_quality_type_id"
    t.integer  "item_id"
    t.integer  "item_revision_id"
    t.integer  "item_alt_name_id"
    t.integer  "po_header_id"
    t.integer  "quantity"
    t.text     "definition_of_issue"
    t.text     "short_term_fix"
    t.integer  "cause_analysis_id"
    t.text     "required_action"
    t.string   "quality_action_status"
    t.date     "due_date"
    t.boolean  "quality_action_active"
    t.datetime "submit_time"
    t.integer  "created_user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.text     "root_cause"
  end

  add_index "quality_actions", ["cause_analysis_id"], :name => "index_quality_actions_on_cause_analysis_id"
  add_index "quality_actions", ["item_alt_name_id"], :name => "index_quality_actions_on_item_alt_name_id"
  add_index "quality_actions", ["item_id"], :name => "index_quality_actions_on_item_id"
  add_index "quality_actions", ["item_revision_id"], :name => "index_quality_actions_on_item_revision_id"
  add_index "quality_actions", ["po_header_id"], :name => "index_quality_actions_on_po_header_id"

  create_table "quality_actions_users", :force => true do |t|
    t.integer  "quality_action_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "quality_actions_users", ["quality_action_id"], :name => "index_quality_actions_users_on_quality_action_id"
  add_index "quality_actions_users", ["user_id"], :name => "index_quality_actions_users_on_user_id"

  create_table "quality_lot_capabilities", :force => true do |t|
    t.integer  "quality_lot_id"
    t.integer  "item_part_dimension_id"
    t.decimal  "lot_dimension_value",      :precision => 25, :scale => 10, :default => 0.0
    t.string   "lot_dimension_status"
    t.text     "lot_dimension_notes"
    t.boolean  "lot_dimension_active"
    t.integer  "lot_dimension_created_id"
    t.integer  "lot_dimension_updated_id"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  add_index "quality_lot_capabilities", ["item_part_dimension_id"], :name => "index_quality_lot_capabilities_on_item_part_dimension_id"
  add_index "quality_lot_capabilities", ["quality_lot_id"], :name => "index_quality_lot_capabilities_on_quality_lot_id"

  create_table "quality_lot_dimensions", :force => true do |t|
    t.integer  "quality_lot_id"
    t.integer  "item_part_dimension_id"
    t.decimal  "lot_dimension_value",      :precision => 25, :scale => 10, :default => 0.0
    t.string   "lot_dimension_status"
    t.text     "lot_dimension_notes"
    t.boolean  "lot_dimension_active"
    t.integer  "lot_dimension_created_id"
    t.integer  "lot_dimension_updated_id"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  add_index "quality_lot_dimensions", ["item_part_dimension_id"], :name => "index_quality_lot_dimensions_on_item_part_dimension_id"
  add_index "quality_lot_dimensions", ["quality_lot_id"], :name => "index_quality_lot_dimensions_on_quality_lot_id"

  create_table "quality_lot_gauge_dimensions", :force => true do |t|
    t.integer  "quality_lot_gauge_id"
    t.integer  "item_part_dimension_id"
    t.boolean  "lot_gauge_dimension_active"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "quality_lot_gauge_dimensions", ["item_part_dimension_id"], :name => "index_quality_lot_gauge_dimensions_on_item_part_dimension_id"
  add_index "quality_lot_gauge_dimensions", ["quality_lot_gauge_id"], :name => "index_quality_lot_gauge_dimensions_on_quality_lot_gauge_id"

  create_table "quality_lot_gauge_results", :force => true do |t|
    t.integer  "quality_lot_gauge_id"
    t.integer  "item_part_dimension_id"
    t.string   "lot_gauge_result_appraiser"
    t.decimal  "lot_gauge_result_value",     :precision => 15, :scale => 10, :default => 0.0
    t.string   "lot_gauge_result_status"
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.integer  "lot_gauge_result_trial"
    t.integer  "lot_gauge_result_row"
  end

  add_index "quality_lot_gauge_results", ["item_part_dimension_id"], :name => "index_quality_lot_gauge_results_on_item_part_dimension_id"
  add_index "quality_lot_gauge_results", ["quality_lot_gauge_id"], :name => "index_quality_lot_gauge_results_on_quality_lot_gauge_id"

  create_table "quality_lot_gauges", :force => true do |t|
    t.integer  "quality_lot_id"
    t.string   "lot_gauge_status"
    t.text     "lot_gauge_notes"
    t.boolean  "lot_gauge_active"
    t.integer  "lot_gauge_created_id"
    t.integer  "lot_gauge_updated_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "quality_lot_gauges", ["quality_lot_id"], :name => "index_quality_lot_gauges_on_quality_lot_id"

  create_table "quality_lot_materials", :force => true do |t|
    t.integer  "quality_lot_id"
    t.integer  "material_element_id"
    t.decimal  "lot_element_low_range",   :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "lot_element_high_range",  :precision => 25, :scale => 10, :default => 0.0
    t.boolean  "lot_material_tested"
    t.string   "lot_material_result"
    t.text     "lot_material_notes"
    t.boolean  "lot_material_active"
    t.integer  "lot_material_created_id"
    t.integer  "lot_material_updated_id"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  add_index "quality_lot_materials", ["material_element_id"], :name => "index_quality_lot_materials_on_material_element_id"
  add_index "quality_lot_materials", ["quality_lot_id"], :name => "index_quality_lot_materials_on_quality_lot_id"

  create_table "quality_lots", :force => true do |t|
    t.integer  "po_header_id"
    t.integer  "po_line_id"
    t.integer  "item_revision_id"
    t.integer  "process_flow_id"
    t.integer  "control_plan_id"
    t.integer  "fmea_type_id"
    t.string   "lot_control_no"
    t.integer  "lot_quantity"
    t.integer  "inspection_level_id"
    t.integer  "inspection_method_id"
    t.integer  "inspection_type_id"
    t.integer  "lot_inspector_id"
    t.datetime "lot_finalized_at"
    t.string   "lot_aql_no",           :default => "1"
    t.text     "lot_notes"
    t.boolean  "lot_active"
    t.integer  "lot_created_id"
    t.integer  "lot_updated_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "lot_shelf_idenifier"
    t.integer  "lot_shelf_unit"
    t.integer  "lot_shelf_number"
    t.integer  "run_at_rate"
    t.integer  "run_at_rate_id"
    t.string   "fai"
    t.boolean  "finished",             :default => false
    t.integer  "quantity_on_hand"
  end

  add_index "quality_lots", ["item_revision_id"], :name => "index_quality_lots_on_item_revision_id"
  add_index "quality_lots", ["po_header_id"], :name => "index_quality_lots_on_po_header_id"
  add_index "quality_lots", ["po_line_id"], :name => "index_quality_lots_on_po_line_id"

  create_table "quote_line_costs", :force => true do |t|
    t.integer  "quote_vendor_id"
    t.integer  "quote_line_id"
    t.decimal  "quote_line_cost",             :precision => 25, :scale => 10, :default => 0.0
    t.text     "quote_line_cost_notes"
    t.integer  "quote_line_cost_created_id"
    t.integer  "quote_line_cost_updated_id"
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
    t.decimal  "quote_line_cost_tooling",     :precision => 25, :scale => 10, :default => 0.0
    t.string   "quote_line_cost_lead"
    t.string   "quote_line_cost_description"
  end

  add_index "quote_line_costs", ["quote_line_id"], :name => "index_quote_line_costs_on_quote_line_id"
  add_index "quote_line_costs", ["quote_vendor_id"], :name => "index_quote_line_costs_on_quote_vendor_id"

  create_table "quote_lines", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "item_id"
    t.integer  "item_revision_id"
    t.integer  "item_alt_name_id"
    t.integer  "po_line_id"
    t.integer  "organization_id"
    t.string   "quote_line_description"
    t.string   "quote_line_identifier"
    t.integer  "quote_line_quantity"
    t.decimal  "quote_line_cost",        :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "quote_line_total",       :precision => 25, :scale => 10, :default => 0.0
    t.string   "quote_line_status"
    t.text     "quote_line_notes"
    t.boolean  "quote_line_active",                                      :default => false
    t.integer  "quote_line_created_id"
    t.integer  "quote_line_updated_id"
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.string   "item_name_sub"
  end

  add_index "quote_lines", ["item_alt_name_id"], :name => "index_quote_lines_on_item_alt_name_id"
  add_index "quote_lines", ["item_id"], :name => "index_quote_lines_on_item_id"
  add_index "quote_lines", ["item_revision_id"], :name => "index_quote_lines_on_item_revision_id"
  add_index "quote_lines", ["organization_id"], :name => "index_quote_lines_on_organization_id"
  add_index "quote_lines", ["po_line_id"], :name => "index_quote_lines_on_po_line_id"
  add_index "quote_lines", ["quote_id"], :name => "index_quote_lines_on_quote_id"

  create_table "quote_vendors", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "organization_id"
    t.string   "quote_vendor_status"
    t.integer  "quote_vendor_created_id"
    t.integer  "quote_vendor_updated_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "quote_vendors", ["organization_id"], :name => "index_quote_vendors_on_organization_id"
  add_index "quote_vendors", ["quote_id"], :name => "index_quote_vendors_on_quote_id"

  create_table "quotes", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "po_header_id"
    t.string   "quote_identifier"
    t.string   "quote_description"
    t.decimal  "quote_total",       :precision => 25, :scale => 10, :default => 0.0
    t.string   "quote_status"
    t.text     "quote_notes"
    t.boolean  "quote_active"
    t.integer  "quote_created_id"
    t.integer  "quote_updated_id"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.integer  "customer_id"
    t.integer  "group_id"
    t.boolean  "attachment_public",                                 :default => false
  end

  add_index "quotes", ["group_id"], :name => "index_quotes_on_group_id"
  add_index "quotes", ["organization_id"], :name => "index_quotes_on_organization_id"
  add_index "quotes", ["po_header_id"], :name => "index_quotes_on_po_header_id"

  create_table "quotes_organizations", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "quote_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "quotes_organizations", ["organization_id"], :name => "index_quotes_organizations_on_organization_id"
  add_index "quotes_organizations", ["quote_id"], :name => "index_quotes_organizations_on_quote_id"

  create_table "quotes_po_headers", :force => true do |t|
    t.integer  "po_header_id"
    t.integer  "quote_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "quotes_po_headers", ["po_header_id"], :name => "index_quotes_po_headers_on_po_header_id"
  add_index "quotes_po_headers", ["quote_id"], :name => "index_quotes_po_headers_on_quote_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "receipt_lines", :force => true do |t|
    t.integer  "receipt_id"
    t.integer  "receivable_id"
    t.decimal  "receipt_line_amount",     :precision => 25, :scale => 10, :default => 0.0
    t.integer  "receipt_line_created_id"
    t.integer  "receipt_line_updated_id"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  add_index "receipt_lines", ["receipt_id"], :name => "index_receipt_lines_on_receipt_id"
  add_index "receipt_lines", ["receivable_id"], :name => "index_receipt_lines_on_receivable_id"

  create_table "receipts", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "receipt_type_id"
    t.string   "receipt_check_code"
    t.decimal  "receipt_check_amount", :precision => 25, :scale => 10, :default => 0.0
    t.string   "receipt_check_no"
    t.string   "receipt_identifier"
    t.string   "receipt_description"
    t.text     "receipt_notes"
    t.string   "receipt_status"
    t.boolean  "receipt_active"
    t.integer  "receipt_created_id"
    t.integer  "receipt_updated_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.integer  "check_entry_id"
  end

  add_index "receipts", ["check_entry_id"], :name => "index_receipts_on_check_entry_id"
  add_index "receipts", ["organization_id"], :name => "index_receipts_on_organization_id"

  create_table "receivable_accounts", :force => true do |t|
    t.integer  "receivable_id"
    t.integer  "gl_account_id"
    t.string   "receivable_account_description"
    t.decimal  "receivable_account_amount",      :precision => 25, :scale => 10, :default => 0.0
    t.integer  "receivable_account_created_id"
    t.integer  "receivable_account_updated_id"
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
  end

  add_index "receivable_accounts", ["gl_account_id"], :name => "index_receivable_accounts_on_gl_account_id"
  add_index "receivable_accounts", ["receivable_id"], :name => "index_receivable_accounts_on_receivable_id"

  create_table "receivable_lines", :force => true do |t|
    t.integer  "receivable_id"
    t.string   "receivable_line_identifier"
    t.string   "receivable_line_description"
    t.decimal  "receivable_line_cost",        :precision => 25, :scale => 10, :default => 0.0
    t.text     "receivable_line_notes"
    t.string   "receivable_line_status"
    t.boolean  "receivable_line_active"
    t.integer  "receivable_line_created_id"
    t.integer  "receivable_line_updated_id"
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  add_index "receivable_lines", ["receivable_id"], :name => "index_receivable_lines_on_receivable_id"

  create_table "receivable_shipments", :force => true do |t|
    t.integer  "receivable_id"
    t.integer  "so_line_id"
    t.string   "receivable_shipment_identifier"
    t.integer  "receivable_shipment_count",                                      :default => 0
    t.decimal  "receivable_shipment_cost",       :precision => 25, :scale => 10, :default => 0.0
    t.integer  "receivable_shipment_created_id"
    t.integer  "receivable_shipment_updated_id"
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
  end

  add_index "receivable_shipments", ["receivable_id"], :name => "index_receivable_shipments_on_receivable_id"
  add_index "receivable_shipments", ["so_line_id"], :name => "index_receivable_shipments_on_so_line_id"

  create_table "receivable_so_shipments", :force => true do |t|
    t.integer  "so_shipment_id"
    t.integer  "receivable_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "receivable_so_shipments", ["receivable_id"], :name => "index_receivable_so_shipments_on_receivable_id"
  add_index "receivable_so_shipments", ["so_shipment_id"], :name => "index_receivable_so_shipments_on_so_shipment_id"

  create_table "receivables", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "so_header_id"
    t.string   "receivable_identifier"
    t.string   "receivable_description"
    t.decimal  "receivable_cost",        :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "receivable_discount",    :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "receivable_total",       :precision => 25, :scale => 10, :default => 0.0
    t.text     "receivable_notes"
    t.string   "receivable_status"
    t.boolean  "receivable_active"
    t.integer  "receivable_created_id"
    t.integer  "receivable_updated_id"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.string   "receivable_invoice"
    t.integer  "gl_account_id"
    t.decimal  "receivable_freight",     :precision => 25, :scale => 10, :default => 0.0
  end

  add_index "receivables", ["gl_account_id"], :name => "index_receivables_on_gl_account_id"
  add_index "receivables", ["organization_id"], :name => "index_receivables_on_organization_id"
  add_index "receivables", ["so_header_id"], :name => "index_receivables_on_so_header_id"

  create_table "reconcileds", :force => true do |t|
    t.float    "balance"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reconciles", :force => true do |t|
    t.string   "reconcile_type"
    t.integer  "payment_id"
    t.string   "tag"
    t.integer  "deposit_check_id"
    t.integer  "printing_screen_id"
    t.string   "reconcile_status"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "receipt_id"
  end

  add_index "reconciles", ["deposit_check_id"], :name => "index_reconciles_on_deposit_check_id"
  add_index "reconciles", ["payment_id"], :name => "index_reconciles_on_payment_id"
  add_index "reconciles", ["printing_screen_id"], :name => "index_reconciles_on_printing_screen_id"

  create_table "run_at_rates", :force => true do |t|
    t.string   "run_at_rate_name"
    t.string   "run_at_rate_description"
    t.text     "run_at_rate_notes"
    t.boolean  "run_at_rate_active"
    t.integer  "run_at_rate_created_id"
    t.integer  "run_at_rate_updated_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "so_headers", :force => true do |t|
    t.integer  "organization_id"
    t.string   "so_identifier"
    t.integer  "so_bill_to_id"
    t.integer  "so_ship_to_id"
    t.boolean  "so_cofc"
    t.boolean  "so_squality"
    t.decimal  "so_total",              :precision => 25, :scale => 10, :default => 0.0
    t.text     "so_notes"
    t.text     "so_comments"
    t.string   "so_status"
    t.integer  "so_created_id"
    t.integer  "so_updated_id"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "so_header_customer_po"
  end

  add_index "so_headers", ["organization_id"], :name => "index_so_headers_on_organization_id"

  create_table "so_lines", :force => true do |t|
    t.integer  "so_header_id"
    t.integer  "item_id"
    t.integer  "item_revision_id"
    t.integer  "item_alt_name_id"
    t.integer  "organization_id"
    t.integer  "vendor_quality_id"
    t.integer  "customer_quality_id"
    t.decimal  "so_line_cost",        :precision => 25, :scale => 10, :default => 0.0
    t.decimal  "so_line_price",       :precision => 25, :scale => 10, :default => 0.0
    t.integer  "so_line_quantity",                                    :default => 0
    t.decimal  "so_line_freight",     :precision => 25, :scale => 10, :default => 0.0
    t.string   "so_line_status"
    t.text     "so_line_notes"
    t.boolean  "so_line_active"
    t.integer  "so_line_created_id"
    t.integer  "so_line_updated_id"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.integer  "so_line_shipped",                                     :default => 0
    t.decimal  "so_line_sell",        :precision => 25, :scale => 10, :default => 0.0
    t.string   "so_line_vendor_po"
  end

  add_index "so_lines", ["customer_quality_id"], :name => "index_so_lines_on_customer_quality_id"
  add_index "so_lines", ["item_alt_name_id"], :name => "index_so_lines_on_item_alt_name_id"
  add_index "so_lines", ["item_id"], :name => "index_so_lines_on_item_id"
  add_index "so_lines", ["item_revision_id"], :name => "index_so_lines_on_item_revision_id"
  add_index "so_lines", ["organization_id"], :name => "index_so_lines_on_organization_id"
  add_index "so_lines", ["so_header_id"], :name => "index_so_lines_on_so_header_id"
  add_index "so_lines", ["vendor_quality_id"], :name => "index_so_lines_on_vendor_quality_id"

  create_table "so_shipments", :force => true do |t|
    t.integer  "so_line_id"
    t.integer  "so_shipped_count",                                       :default => 0
    t.decimal  "so_shipped_cost",        :precision => 25, :scale => 10, :default => 0.0
    t.string   "so_shipped_shelf"
    t.string   "so_shipped_unit"
    t.string   "so_shipped_status"
    t.integer  "so_shipment_created_id"
    t.integer  "so_shipment_updated_id"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.integer  "quality_lot_id",                                         :default => 0
  end

  add_index "so_shipments", ["so_line_id"], :name => "index_so_shipments_on_so_line_id"

  create_table "specifications", :force => true do |t|
    t.boolean  "specification_active"
    t.integer  "specification_created_id"
    t.integer  "specification_updated_id"
    t.string   "specification_identifier"
    t.string   "specification_description"
    t.text     "specification_notes"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "territories", :force => true do |t|
    t.boolean  "territory_active"
    t.integer  "territory_created_id"
    t.integer  "territory_updated_id"
    t.string   "territory_identifier"
    t.string   "territory_description"
    t.string   "territory_zip"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
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
    t.integer  "roles_mask"
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
