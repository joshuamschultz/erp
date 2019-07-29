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

ActiveRecord::Schema.define(version: 2019_07_10_153248) do

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "addressable_id"
    t.string "addressable_type"
    t.string "address_type"
    t.string "address_title"
    t.string "address_description"
    t.text "address_address_1"
    t.text "address_address_2"
    t.string "address_city"
    t.string "address_state"
    t.string "address_country"
    t.string "address_zipcode"
    t.string "address_telephone"
    t.string "address_fax"
    t.string "address_email"
    t.string "address_website"
    t.text "address_notes"
    t.boolean "address_active"
    t.integer "address_created_id"
    t.integer "address_updated_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "attachable_id"
    t.string "attachable_type"
    t.string "attachment_file_name"
    t.string "attachment_file_size"
    t.string "attachment_content_type"
    t.string "attachment_revision_title"
    t.date "attachment_revision_date"
    t.date "attachment_effective_date"
    t.string "attachment_name"
    t.string "attachment_description"
    t.string "attachment_document_type"
    t.integer "attachment_document_type_id"
    t.text "attachment_notes"
    t.boolean "attachment_public", default: false
    t.boolean "attachment_active", default: false
    t.string "attachment_status"
    t.integer "attachment_status_id"
    t.integer "attachment_created_id"
    t.integer "attachment_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "capacity_plannings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "capacity_plan_name"
    t.string "capacity_plan_description"
    t.text "capacity_plan_notes"
    t.boolean "capacity_plan_active"
    t.integer "capacity_plan_created_id"
    t.integer "capacity_plan_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cause_analyses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "notes"
    t.boolean "active"
    t.integer "created_id"
    t.integer "updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "check_codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "counter"
    t.string "counter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "check_entries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "check_identifier"
    t.string "check_code"
    t.boolean "check_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status"
  end

  create_table "check_list_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "checklist_id"
    t.integer "master_type_id"
    t.boolean "check_list_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["checklist_id"], name: "index_check_list_lines_on_checklist_id"
    t.index ["master_type_id"], name: "index_check_list_lines_on_master_type_id"
  end

  create_table "check_registers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "transaction_date"
    t.string "check_code"
    t.integer "organization_id"
    t.decimal "amount", precision: 10
    t.decimal "deposit", precision: 10
    t.decimal "balance", precision: 10
    t.boolean "rec"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "payment_id"
    t.integer "receipt_id"
  end

  create_table "checklists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.string "checklist_status"
    t.integer "po_line_id"
    t.integer "customer_quality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["customer_quality_id"], name: "index_checklists_on_customer_quality_id"
    t.index ["po_line_id"], name: "index_checklists_on_po_line_id"
    t.index ["quality_lot_id"], name: "index_checklists_on_quality_lot_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "comment"
    t.string "comment_type"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.boolean "comment_active"
    t.integer "comment_created_id"
    t.integer "comment_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commodities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "commodity_active"
    t.string "commodity_identifier"
    t.string "commodity_description"
    t.text "commodity_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "company_name"
    t.text "company_address1"
    t.text "company_address2"
    t.string "company_phone1"
    t.string "company_phone2"
    t.string "company_mobile"
    t.string "company_fax"
    t.string "company_website"
    t.string "company_slogan"
    t.boolean "company_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "contactable_id"
    t.string "contactable_type"
    t.string "contact_type"
    t.string "contact_title"
    t.string "contact_description"
    t.text "contact_address_1"
    t.text "contact_address_2"
    t.string "contact_city"
    t.string "contact_state"
    t.string "contact_country"
    t.string "contact_zipcode"
    t.string "contact_telephone"
    t.string "contact_fax"
    t.string "contact_email"
    t.string "contact_website"
    t.text "contact_notes"
    t.boolean "contact_active"
    t.integer "contact_created_id"
    t.integer "contact_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name"
    t.string "last_name"
  end

  create_table "control_plans", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "plan_name"
    t.string "plan_description"
    t.text "plan_notes"
    t.boolean "plan_active"
    t.integer "plan_created_id"
    t.integer "plan_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_registers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "transaction_date"
    t.integer "payment_id"
    t.integer "organization_id"
    t.decimal "amount", precision: 10
    t.decimal "balance", precision: 10
    t.boolean "rec"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "receipt_id"
  end

  create_table "customer_feedbacks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.string "title"
    t.text "feedback"
    t.integer "quality_action_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "customer_feedback_type_id"
    t.index ["organization_id"], name: "index_customer_feedbacks_on_organization_id"
    t.index ["user_id"], name: "index_customer_feedbacks_on_user_id"
  end

  create_table "customer_qualities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "quality_name"
    t.string "quality_description"
    t.text "quality_notes"
    t.boolean "quality_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_quality_levels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "customer_quality_id"
    t.integer "master_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["customer_quality_id"], name: "index_customer_quality_levels_on_customer_quality_id"
    t.index ["master_type_id"], name: "index_customer_quality_levels_on_master_type_id"
  end

  create_table "customer_quote_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "customer_quote_id"
    t.integer "item_id"
    t.integer "item_revision_id"
    t.integer "item_alt_name_id"
    t.integer "quote_vendor_id"
    t.string "customer_quote_line_description"
    t.string "customer_quote_line_identifier"
    t.integer "customer_quote_line_quantity"
    t.decimal "customer_quote_line_cost", precision: 25, scale: 10, default: "0.0"
    t.string "customer_quote_line_status"
    t.text "customer_quote_line_notes"
    t.boolean "customer_quote_line_active"
    t.integer "customer_quote_line_created_id"
    t.integer "customer_quote_line_updated_id"
    t.decimal "customer_quote_line_tooling_cost", precision: 25, scale: 10, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "customer_quote_line_total", precision: 25, scale: 10, default: "0.0"
    t.string "lead_time"
    t.string "item_name_sub"
    t.integer "quote_id"
    t.index ["customer_quote_id"], name: "index_customer_quote_lines_on_customer_quote_id"
    t.index ["item_alt_name_id"], name: "index_customer_quote_lines_on_item_alt_name_id"
    t.index ["item_id"], name: "index_customer_quote_lines_on_item_id"
    t.index ["item_revision_id"], name: "index_customer_quote_lines_on_item_revision_id"
    t.index ["quote_vendor_id"], name: "index_customer_quote_lines_on_quote_vendor_id"
  end

  create_table "customer_quotes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.string "customer_quote_identifier"
    t.string "customer_quote_description"
    t.string "customer_quote_status"
    t.text "customer_quote_notes"
    t.boolean "customer_quote_active"
    t.integer "customer_quote_created_id"
    t.integer "customer_quote_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["organization_id"], name: "index_customer_quotes_on_organization_id"
  end

  create_table "deposit_checks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.integer "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "receipt_id"
    t.string "receipt_type"
    t.string "check_identifier"
    t.integer "active"
    t.index ["payment_id"], name: "index_deposit_checks_on_payment_id"
  end

  create_table "dimensions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "dimension_identifier"
    t.string "dimension_description"
    t.text "dimension_notes"
    t.boolean "dimension_active"
    t.integer "dimension_created_id"
    t.integer "dimension_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "element_name"
    t.string "element_symbol"
    t.text "element_notes"
    t.integer "element_created_id"
    t.integer "element_updated_id"
    t.boolean "element_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string "allDay"
    t.string "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "repeats"
    t.text "description"
    t.integer "user_id"
    t.integer "frequency"
    t.integer "parent_id"
  end

  create_table "fmea_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "fmea_name"
    t.string "fmea_description"
    t.text "fmea_notes"
    t.boolean "fmea_active"
    t.integer "fmea_created_id"
    t.integer "fmea_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gauges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.string "gauge_tool_name"
    t.string "gauge_tool_category"
    t.string "gauge_tool_no"
    t.date "gage_caliberation_last_at"
    t.date "gage_caliberation_due_at"
    t.integer "gage_caliberaion_period"
    t.boolean "gauge_active"
    t.integer "gauge_created_id"
    t.integer "gauge_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["organization_id"], name: "index_gauges_on_organization_id"
  end

  create_table "gl_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "gl_type_id"
    t.string "gl_account_title"
    t.string "gl_account_identifier"
    t.string "gl_account_description"
    t.boolean "gl_account_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "gl_account_amount", precision: 15, scale: 10, default: "0.0"
    t.boolean "key_account", default: true
    t.index ["gl_type_id"], name: "index_gl_accounts_on_gl_type_id"
  end

  create_table "gl_entries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "gl_entry_identifier"
    t.integer "gl_account_id"
    t.string "gl_entry_description"
    t.date "gl_entry_date", default: "2017-06-21"
    t.decimal "gl_entry_credit", precision: 25, scale: 10, default: "0.0"
    t.decimal "gl_entry_debit", precision: 25, scale: 10, default: "0.0"
    t.text "gl_entry_notes"
    t.boolean "gl_entry_active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "payable_id"
    t.integer "payable_account_id"
    t.integer "receivable_account_id"
    t.integer "receivable_id"
    t.integer "payment_id"
    t.integer "receipt_id"
    t.index ["gl_account_id"], name: "index_gl_entries_on_gl_account_id"
  end

  create_table "gl_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "gl_name"
    t.string "gl_side"
    t.string "gl_report"
    t.string "gl_identifier"
    t.string "gl_description"
    t.boolean "gl_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_organizations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id"], name: "index_group_organizations_on_group_id"
    t.index ["organization_id"], name: "index_group_organizations_on_organization_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "group_name"
    t.string "group_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "imageable_id"
    t.string "imageable_type"
    t.string "image_title"
    t.string "image_description"
    t.text "image_notes"
    t.string "image_file_name"
    t.string "image_file_size"
    t.string "image_content_type"
    t.boolean "image_public"
    t.boolean "image_active"
    t.integer "image_created_id"
    t.integer "image_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventory_adjustments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "inventory_adjustment_quantity"
    t.string "inventory_adjustment_description"
    t.integer "item_id"
    t.integer "item_alt_name_id"
    t.integer "quality_lot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_alt_names", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_alt_identifier"
    t.string "item_alt_description"
    t.text "item_alt_notes"
    t.boolean "item_alt_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "organization_id"
    t.integer "item_id"
  end

  create_table "item_lots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.integer "item_id"
    t.integer "item_lot_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_materials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_revision_id"
    t.integer "material_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_revision_id"], name: "index_item_materials_on_item_revision_id"
    t.index ["material_id"], name: "index_item_materials_on_material_id"
  end

  create_table "item_part_dimensions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_revision_id"
    t.integer "dimension_id"
    t.integer "gauge_id"
    t.string "item_part_letter"
    t.decimal "item_part_dimension", precision: 15, scale: 10, default: "0.0"
    t.decimal "item_part_pos_tolerance", precision: 15, scale: 10, default: "0.0"
    t.decimal "item_part_neg_tolerance", precision: 15, scale: 10, default: "0.0"
    t.boolean "item_part_critical"
    t.text "item_part_notes"
    t.boolean "item_part_active"
    t.integer "item_part_created_id"
    t.integer "item_part_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "go_non_go", default: false
    t.string "dimension_string"
    t.index ["dimension_id"], name: "index_item_part_dimensions_on_dimension_id"
    t.index ["gauge_id"], name: "index_item_part_dimensions_on_gauge_id"
    t.index ["item_revision_id"], name: "index_item_part_dimensions_on_item_revision_id"
  end

  create_table "item_prints", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_revision_id"
    t.integer "print_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_revision_id"], name: "index_item_prints_on_item_revision_id"
    t.index ["print_id"], name: "index_item_prints_on_print_id"
  end

  create_table "item_processes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_revision_id"
    t.integer "process_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_revision_id"], name: "index_item_processes_on_item_revision_id"
    t.index ["process_type_id"], name: "index_item_processes_on_process_type_id"
  end

  create_table "item_revision_item_part_dimensions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_revision_id"
    t.integer "item_part_dimension_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_revisions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_revision_name", default: "0"
    t.date "item_revision_date"
    t.integer "item_id"
    t.integer "organization_id"
    t.integer "vendor_quality_id"
    t.integer "customer_quality_id"
    t.string "item_name"
    t.text "item_description"
    t.text "item_notes"
    t.decimal "item_tooling", precision: 25, scale: 10, default: "0.0"
    t.decimal "item_cost", precision: 25, scale: 10, default: "0.0"
    t.integer "item_revision_created_id"
    t.integer "item_revision_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "print_id"
    t.integer "material_id"
    t.boolean "latest_revision"
    t.boolean "item_revision_complete", default: false
    t.decimal "item_sell", precision: 15, scale: 10
    t.integer "lot_count", default: 0
    t.index ["customer_quality_id"], name: "index_item_revisions_on_customer_quality_id"
    t.index ["item_id"], name: "index_item_revisions_on_item_id"
    t.index ["organization_id"], name: "index_item_revisions_on_organization_id"
    t.index ["vendor_quality_id"], name: "index_item_revisions_on_vendor_quality_id"
  end

  create_table "item_selected_names", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_revision_id"
    t.integer "item_alt_name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_alt_name_id"], name: "index_item_selected_names_on_item_alt_name_id"
    t.index ["item_revision_id"], name: "index_item_selected_names_on_item_revision_id"
  end

  create_table "item_specifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_revision_id"
    t.integer "specification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_revision_id"], name: "index_item_specifications_on_item_revision_id"
    t.index ["specification_id"], name: "index_item_specifications_on_specification_id"
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_part_no"
    t.integer "item_quantity_on_order"
    t.integer "item_quantity_in_hand"
    t.boolean "item_active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "lot_count"
    t.string "item_alt_part_no"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_items_on_deleted_at"
  end

  create_table "logos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "jointable_id"
    t.string "jointable_type"
    t.string "joint_title"
    t.string "joint_description"
    t.text "joint_notes"
    t.string "joint_file_name"
    t.string "joint_file_size"
    t.string "joint_content_type"
    t.datetime "joint_updated_at"
    t.boolean "joint_public"
    t.boolean "joint_active"
    t.integer "joint_created_id"
    t.integer "joint_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "master_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type_name"
    t.string "type_description"
    t.string "type_category"
    t.boolean "type_active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "type_value"
    t.string "master_type"
    t.integer "quality_document_id"
  end

  create_table "material_elements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "material_id"
    t.integer "element_id"
    t.string "element_symbol"
    t.string "element_name"
    t.decimal "element_low_range", precision: 25, scale: 10, default: "0.0"
    t.decimal "element_high_range", precision: 25, scale: 10, default: "0.0"
    t.boolean "element_active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["element_id"], name: "index_material_elements_on_element_id"
    t.index ["material_id"], name: "index_material_elements_on_material_id"
  end

  create_table "materials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "material_short_name"
    t.string "material_description"
    t.text "material_notes"
    t.boolean "material_active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "max_control_strings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "control_string"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "control_string_second"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "notable_id"
    t.string "notable_type"
    t.string "note_status"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_processes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "process_type_id"
    t.boolean "org_process_active"
    t.integer "org_process_created_id"
    t.integer "org_process_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["organization_id"], name: "index_organization_processes_on_organization_id"
    t.index ["process_type_id"], name: "index_organization_processes_on_process_type_id"
  end

  create_table "organization_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.string "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_type_id"
    t.integer "territory_id"
    t.integer "customer_quality_id"
    t.integer "customer_contact_type_id"
    t.integer "customer_max_quality_id"
    t.integer "vendor_quality_id"
    t.date "vendor_expiration_date"
    t.string "organization_name"
    t.string "organization_short_name"
    t.string "organization_description"
    t.string "organization_address_1"
    t.string "organization_address_2"
    t.string "organization_city"
    t.string "organization_state"
    t.string "organization_country"
    t.string "organization_zipcode"
    t.string "organization_telephone"
    t.string "organization_fax"
    t.string "organization_email"
    t.string "organization_website"
    t.text "organization_notes"
    t.boolean "organization_active", default: true
    t.integer "organization_created_id"
    t.integer "organization_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "customer_min_quality_id"
    t.boolean "organization_complete", default: false
    t.datetime "deleted_at"
    t.index ["customer_quality_id"], name: "index_organizations_on_customer_quality_id"
    t.index ["deleted_at"], name: "index_organizations_on_deleted_at"
    t.index ["territory_id"], name: "index_organizations_on_territory_id"
    t.index ["user_id"], name: "index_organizations_on_user_id"
    t.index ["vendor_quality_id"], name: "index_organizations_on_vendor_quality_id"
  end

  create_table "packages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.decimal "part_size_length", precision: 10
    t.decimal "part_size_width", precision: 10
    t.decimal "part_size_height", precision: 10
    t.decimal "container_length", precision: 10
    t.decimal "container_width", precision: 10
    t.decimal "container_height", precision: 10
    t.decimal "pallet_length", precision: 10
    t.decimal "pallet_width", precision: 10
    t.decimal "pallet_height", precision: 10
    t.decimal "load_shipped_length", precision: 10
    t.decimal "load_shipped_width", precision: 10
    t.decimal "load_shipped_height", precision: 10
    t.decimal "part_weight", precision: 10
    t.decimal "dunnage_tare_Weight", precision: 10
    t.decimal "container_tare_weight", precision: 10
    t.decimal "pallet_tare_weight", precision: 10
    t.decimal "container_gross_inc_weight", precision: 10
    t.decimal "unit_load_gross", precision: 10
    t.integer "quantity_per_container"
    t.integer "container_per_layer_pallet"
    t.integer "layers_per_pallet"
    t.integer "container_per_pallet"
    t.text "package_comment"
    t.string "part_content_type"
    t.integer "part_file_size"
    t.datetime "part_updated_at"
    t.string "part_file_name"
    t.string "container_content_type"
    t.integer "container_file_size"
    t.datetime "container_updated_at"
    t.string "container_file_name"
    t.string "dunnage_content_type"
    t.integer "dunnage_file_size"
    t.datetime "dunnage_updated_at"
    t.string "dunnage_file_name"
    t.string "unit_load_content_type"
    t.integer "unit_load_file_size"
    t.datetime "unit_load_updated_at"
    t.string "unit_load_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "dunnage_manufacturer"
    t.text "container_color_manufacturer"
    t.text "container_type_manufacturer"
    t.text "cover_cap_manufacturer"
    t.text "pallet_manufacturer"
    t.text "strech_shrink_manufacturer"
    t.text "banding_manufacturer"
    t.text "other_manufacturer"
    t.text "dunnage_material"
    t.text "container_color_material"
    t.text "container_type_material"
    t.text "cover_cap_material"
    t.text "pallet_material"
    t.text "strech_shrink_material"
    t.text "banding_material"
    t.text "other_material"
    t.text "dunnage_lead_time"
    t.text "container_color_lead_time"
    t.text "container_type_lead_time"
    t.text "cover_cap_lead_time"
    t.text "pallet_lead_time"
    t.text "strech_shrink_lead_time"
    t.text "banding_lead_time"
    t.text "other_lead_time"
    t.text "dunnage_ret_exp"
    t.text "container_color_ret_exp"
    t.text "container_type_ret_exp"
    t.text "cover_cap_ret_exp"
    t.text "pallet_ret_exp"
    t.text "strech_shrink_ret_exp"
    t.text "banding_ret_exp"
    t.text "other_ret_exp"
    t.text "dunnage_comment"
    t.text "container_color_comment"
    t.text "container_type_comment"
    t.text "cover_cap_comment"
    t.text "pallet_comment"
    t.text "strech_shrink_comment"
    t.text "banding_comment"
    t.text "other_comment"
    t.decimal "in_to_mm1", precision: 10
    t.decimal "in_to_mm2", precision: 10
    t.decimal "lbs_to_kg1", precision: 10
    t.decimal "lbs_to_kg2", precision: 10
    t.string "supplier_code"
  end

  create_table "payable_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "payable_id"
    t.integer "gl_account_id"
    t.string "payable_account_description"
    t.decimal "payable_account_amount", precision: 25, scale: 10, default: "0.0"
    t.integer "payable_account_created_id"
    t.integer "payable_account_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "gl_entry_id"
    t.index ["gl_account_id"], name: "index_payable_accounts_on_gl_account_id"
    t.index ["payable_id"], name: "index_payable_accounts_on_payable_id"
  end

  create_table "payable_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "payable_id"
    t.string "payable_line_identifier"
    t.string "payable_line_description"
    t.decimal "payable_line_cost", precision: 25, scale: 10, default: "0.0"
    t.text "payable_line_notes"
    t.string "payable_line_status"
    t.boolean "payable_line_active"
    t.integer "payable_line_created_id"
    t.integer "payable_line_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["payable_id"], name: "index_payable_lines_on_payable_id"
  end

  create_table "payable_po_shipments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "po_shipment_id"
    t.integer "payable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["payable_id"], name: "index_payable_po_shipments_on_payable_id"
    t.index ["po_shipment_id"], name: "index_payable_po_shipments_on_po_shipment_id"
  end

  create_table "payable_shipments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "payable_id"
    t.integer "po_line_id"
    t.string "payable_shipment_identifier"
    t.integer "payable_shipment_count", default: 0
    t.decimal "payable_shipment_cost", precision: 25, scale: 10, default: "0.0"
    t.integer "payable_shipment_created_id"
    t.integer "payable_shipment_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["payable_id"], name: "index_payable_shipments_on_payable_id"
    t.index ["po_line_id"], name: "index_payable_shipments_on_po_line_id"
  end

  create_table "payables", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "po_header_id"
    t.integer "payable_to_id"
    t.string "payable_identifier"
    t.string "payable_description"
    t.decimal "payable_cost", precision: 25, scale: 10, default: "0.0"
    t.decimal "payable_discount", precision: 25, scale: 10, default: "0.0"
    t.decimal "payable_total", precision: 25, scale: 10, default: "0.0"
    t.date "payable_invoice_date"
    t.date "payable_due_date"
    t.text "payable_notes"
    t.string "payable_status"
    t.boolean "payable_active"
    t.integer "payable_created_id"
    t.integer "payable_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "payable_freight", precision: 25, scale: 10, default: "0.0"
    t.string "payable_invoice"
    t.integer "gl_account_id"
    t.string "payable_type"
    t.string "payable_disperse"
    t.index ["gl_account_id"], name: "index_payables_on_gl_account_id"
    t.index ["organization_id"], name: "index_payables_on_organization_id"
    t.index ["po_header_id"], name: "index_payables_on_po_header_id"
  end

  create_table "payment_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "payment_id"
    t.integer "payable_id"
    t.decimal "payment_line_amount", precision: 25, scale: 10, default: "0.0"
    t.integer "payment_line_created_id"
    t.integer "payment_line_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["payable_id"], name: "index_payment_lines_on_payable_id"
    t.index ["payment_id"], name: "index_payment_lines_on_payment_id"
  end

  create_table "payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "payment_type_id"
    t.string "payment_check_code"
    t.decimal "payment_check_amount", precision: 25, scale: 10, default: "0.0"
    t.string "payment_check_no"
    t.string "payment_identifier"
    t.string "payment_description"
    t.text "payment_notes"
    t.string "payment_status"
    t.boolean "payment_active"
    t.integer "payment_created_id"
    t.integer "payment_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "check_entry_id"
    t.integer "check_register_id"
    t.string "payment_check_code_type"
    t.index ["check_entry_id"], name: "index_payments_on_check_entry_id"
    t.index ["organization_id"], name: "index_payments_on_organization_id"
  end

  create_table "po_headers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "po_type_id"
    t.integer "organization_id"
    t.string "po_identifier"
    t.string "po_description"
    t.decimal "po_total", precision: 25, scale: 10, default: "0.0"
    t.string "po_status"
    t.text "po_notes"
    t.boolean "po_active"
    t.integer "po_created_id"
    t.integer "po_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "customer_id"
    t.integer "po_bill_to_id"
    t.integer "po_ship_to_id"
    t.string "cusotmer_po"
    t.integer "so_header_id"
    t.index ["organization_id"], name: "index_po_headers_on_organization_id"
    t.index ["so_header_id"], name: "index_po_headers_on_so_header_id"
  end

  create_table "po_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "po_header_id"
    t.integer "organization_id"
    t.integer "so_line_id"
    t.integer "vendor_quality_id"
    t.integer "customer_quality_id"
    t.integer "item_id"
    t.integer "item_revision_id"
    t.integer "item_selected_name_id"
    t.integer "item_alt_name_id"
    t.string "po_line_customer_po"
    t.decimal "po_line_cost", precision: 25, scale: 10, default: "0.0"
    t.integer "po_line_quantity", default: 0
    t.decimal "po_line_total", precision: 25, scale: 10, default: "0.0"
    t.string "po_line_status"
    t.text "po_line_notes"
    t.boolean "po_line_active"
    t.integer "po_line_created_id"
    t.integer "po_line_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "po_line_shipped", default: 0
    t.integer "alt_name_transfer_id"
    t.decimal "po_line_sell", precision: 25, scale: 10, default: "0.0"
    t.integer "quality_lot_id"
    t.integer "process_type_id"
    t.index ["alt_name_transfer_id"], name: "index_po_lines_on_alt_name_transfer_id"
    t.index ["customer_quality_id"], name: "index_po_lines_on_customer_quality_id"
    t.index ["item_id"], name: "index_po_lines_on_item_id"
    t.index ["item_revision_id"], name: "index_po_lines_on_item_revision_id"
    t.index ["organization_id"], name: "index_po_lines_on_organization_id"
    t.index ["po_header_id"], name: "index_po_lines_on_po_header_id"
    t.index ["so_line_id"], name: "index_po_lines_on_so_line_id"
    t.index ["vendor_quality_id"], name: "index_po_lines_on_vendor_quality_id"
  end

  create_table "po_shipments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "po_line_id"
    t.integer "po_shipped_count", default: 0
    t.decimal "po_shipped_cost", precision: 25, scale: 10, default: "0.0"
    t.string "po_shipped_shelf"
    t.string "po_shipped_unit"
    t.string "po_shipped_status"
    t.integer "po_shipment_created_id"
    t.integer "po_shipment_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "quality_lot_id"
    t.index ["po_line_id"], name: "index_po_shipments_on_po_line_id"
  end

  create_table "ppaps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.boolean "initial_submission", default: false
    t.boolean "re_submission", default: false
    t.boolean "change_to_materials_used", default: false
    t.boolean "revision_change", default: false
    t.boolean "camo_pattern_new_to_part", default: false
    t.boolean "tooling_replacement", default: false
    t.boolean "process_change", default: false
    t.boolean "Change_in_mfg_source", default: false
    t.boolean "level1", default: false
    t.boolean "level2", default: false
    t.boolean "level3", default: false
    t.boolean "level4", default: false
    t.boolean "level5", default: false
    t.boolean "purchasing_agreement", default: false
    t.boolean "first_article_parts", default: false
    t.boolean "part_submission_warrant", default: false
    t.boolean "fai_dimensional_inspection", default: false
    t.boolean "packaging_shipping", default: false
    t.boolean "fai_material_test_result", default: false
    t.boolean "component_review_meeting", default: false
    t.boolean "guage_review", default: false
    t.boolean "dfmea_desing", default: false
    t.boolean "measurement_analysis", default: false
    t.boolean "process_flow_diagram", default: false
    t.boolean "process_capabilty_study", default: false
    t.boolean "pfmea_analysis", default: false
    t.boolean "production_run_rate", default: false
    t.boolean "control_plan", default: false
    t.boolean "appearance_report", default: false
    t.boolean "Other", default: false
    t.boolean "result_meeting_yes", default: false
    t.boolean "result_meeting_no", default: false
    t.integer "past_hour"
    t.integer "hour_run"
    t.integer "date"
    t.integer "commited_weekly_capacity"
    t.integer "maximum_weekly_capacity"
    t.string "lathe_cnc"
    t.text "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["quality_lot_id"], name: "index_ppaps_on_quality_lot_id"
  end

  create_table "printing_screens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.integer "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["payment_id"], name: "index_printing_screens_on_payment_id"
  end

  create_table "prints", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "print_active"
    t.integer "print_created_id"
    t.integer "print_updated_id"
    t.string "print_identifier"
    t.string "print_description"
    t.text "print_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "process_flows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "process_identifier"
    t.string "process_name"
    t.string "process_description"
    t.text "process_notes"
    t.boolean "process_active"
    t.integer "process_created_id"
    t.integer "process_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "process_type_specifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "process_type_id"
    t.integer "specification_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "process_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "process_short_name"
    t.string "process_description"
    t.text "process_notes"
    t.boolean "process_active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quality_action_numbers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "next_action_no", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quality_actions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_action_no"
    t.integer "ic_action_id"
    t.integer "organization_quality_type_id"
    t.integer "item_id"
    t.integer "item_revision_id"
    t.integer "item_alt_name_id"
    t.integer "po_header_id"
    t.integer "quantity"
    t.text "definition_of_issue"
    t.text "short_term_fix"
    t.integer "cause_analysis_id"
    t.text "required_action"
    t.string "quality_action_status"
    t.date "due_date"
    t.boolean "quality_action_active"
    t.datetime "submit_time"
    t.integer "created_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "root_cause"
    t.integer "quality_lot_id"
    t.index ["cause_analysis_id"], name: "index_quality_actions_on_cause_analysis_id"
    t.index ["item_alt_name_id"], name: "index_quality_actions_on_item_alt_name_id"
    t.index ["item_id"], name: "index_quality_actions_on_item_id"
    t.index ["item_revision_id"], name: "index_quality_actions_on_item_revision_id"
    t.index ["po_header_id"], name: "index_quality_actions_on_po_header_id"
  end

  create_table "quality_actions_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_action_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["quality_action_id"], name: "index_quality_actions_users_on_quality_action_id"
    t.index ["user_id"], name: "index_quality_actions_users_on_user_id"
  end

  create_table "quality_documents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "quality_document_name"
  end

  create_table "quality_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.string "quality_status"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quality_lot_capabilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.integer "item_part_dimension_id"
    t.decimal "lot_dimension_value", precision: 25, scale: 10, default: "0.0"
    t.string "lot_dimension_status"
    t.text "lot_dimension_notes"
    t.boolean "lot_dimension_active"
    t.integer "lot_dimension_created_id"
    t.integer "lot_dimension_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_part_dimension_id"], name: "index_quality_lot_capabilities_on_item_part_dimension_id"
    t.index ["quality_lot_id"], name: "index_quality_lot_capabilities_on_quality_lot_id"
  end

  create_table "quality_lot_dimensions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.integer "item_part_dimension_id"
    t.decimal "lot_dimension_value", precision: 25, scale: 10, default: "0.0"
    t.string "lot_dimension_status"
    t.text "lot_dimension_notes"
    t.boolean "lot_dimension_active"
    t.integer "lot_dimension_created_id"
    t.integer "lot_dimension_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_part_dimension_id"], name: "index_quality_lot_dimensions_on_item_part_dimension_id"
    t.index ["quality_lot_id"], name: "index_quality_lot_dimensions_on_quality_lot_id"
  end

  create_table "quality_lot_gauge_dimensions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_gauge_id"
    t.integer "item_part_dimension_id"
    t.boolean "lot_gauge_dimension_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_part_dimension_id"], name: "index_quality_lot_gauge_dimensions_on_item_part_dimension_id"
    t.index ["quality_lot_gauge_id"], name: "index_quality_lot_gauge_dimensions_on_quality_lot_gauge_id"
  end

  create_table "quality_lot_gauge_results", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_gauge_id"
    t.integer "item_part_dimension_id"
    t.string "lot_gauge_result_appraiser"
    t.decimal "lot_gauge_result_value", precision: 15, scale: 10, default: "0.0"
    t.string "lot_gauge_result_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "lot_gauge_result_trial"
    t.integer "lot_gauge_result_row"
    t.index ["item_part_dimension_id"], name: "index_quality_lot_gauge_results_on_item_part_dimension_id"
    t.index ["quality_lot_gauge_id"], name: "index_quality_lot_gauge_results_on_quality_lot_gauge_id"
  end

  create_table "quality_lot_gauges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.string "lot_gauge_status"
    t.text "lot_gauge_notes"
    t.boolean "lot_gauge_active"
    t.integer "lot_gauge_created_id"
    t.integer "lot_gauge_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["quality_lot_id"], name: "index_quality_lot_gauges_on_quality_lot_id"
  end

  create_table "quality_lot_materials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quality_lot_id"
    t.integer "material_element_id"
    t.decimal "lot_element_low_range", precision: 25, scale: 10, default: "0.0"
    t.decimal "lot_element_high_range", precision: 25, scale: 10, default: "0.0"
    t.boolean "lot_material_tested"
    t.string "lot_material_result"
    t.text "lot_material_notes"
    t.boolean "lot_material_active"
    t.integer "lot_material_created_id"
    t.integer "lot_material_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["material_element_id"], name: "index_quality_lot_materials_on_material_element_id"
    t.index ["quality_lot_id"], name: "index_quality_lot_materials_on_quality_lot_id"
  end

  create_table "quality_lots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "po_header_id"
    t.integer "po_line_id"
    t.integer "item_revision_id"
    t.integer "process_flow_id"
    t.integer "control_plan_id"
    t.integer "fmea_type_id"
    t.string "lot_control_no"
    t.integer "lot_quantity"
    t.integer "inspection_level_id"
    t.integer "inspection_method_id"
    t.integer "inspection_type_id"
    t.integer "lot_inspector_id"
    t.datetime "lot_finalized_at"
    t.string "lot_aql_no", default: "1"
    t.text "lot_notes"
    t.boolean "lot_active"
    t.integer "lot_created_id"
    t.integer "lot_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "lot_shelf_idenifier"
    t.integer "lot_shelf_unit"
    t.integer "lot_shelf_number"
    t.integer "run_at_rate_id"
    t.string "fai"
    t.boolean "finished", default: false
    t.integer "quantity_on_hand"
    t.string "lot_status"
    t.datetime "final_date"
    t.string "lot_print_status"
    t.string "lot_unit"
    t.string "lot_self"
    t.index ["item_revision_id"], name: "index_quality_lots_on_item_revision_id"
    t.index ["po_header_id"], name: "index_quality_lots_on_po_header_id"
    t.index ["po_line_id"], name: "index_quality_lots_on_po_line_id"
  end

  create_table "quote_line_costs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quote_vendor_id"
    t.integer "quote_line_id"
    t.decimal "quote_line_cost", precision: 25, scale: 10, default: "0.0"
    t.text "quote_line_cost_notes"
    t.integer "quote_line_cost_created_id"
    t.integer "quote_line_cost_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "quote_line_cost_tooling", precision: 25, scale: 10, default: "0.0"
    t.string "quote_line_cost_lead"
    t.string "quote_line_cost_description"
    t.index ["quote_line_id"], name: "index_quote_line_costs_on_quote_line_id"
    t.index ["quote_vendor_id"], name: "index_quote_line_costs_on_quote_vendor_id"
  end

  create_table "quote_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quote_id"
    t.integer "item_id"
    t.integer "item_revision_id"
    t.integer "item_alt_name_id"
    t.integer "po_line_id"
    t.integer "organization_id"
    t.string "quote_line_description"
    t.string "quote_line_identifier"
    t.integer "quote_line_quantity"
    t.decimal "quote_line_cost", precision: 25, scale: 10, default: "0.0"
    t.decimal "quote_line_total", precision: 25, scale: 10, default: "0.0"
    t.string "quote_line_status"
    t.text "quote_line_notes"
    t.boolean "quote_line_active", default: false
    t.integer "quote_line_created_id"
    t.integer "quote_line_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "item_name_sub"
    t.index ["item_alt_name_id"], name: "index_quote_lines_on_item_alt_name_id"
    t.index ["item_id"], name: "index_quote_lines_on_item_id"
    t.index ["item_revision_id"], name: "index_quote_lines_on_item_revision_id"
    t.index ["organization_id"], name: "index_quote_lines_on_organization_id"
    t.index ["po_line_id"], name: "index_quote_lines_on_po_line_id"
    t.index ["quote_id"], name: "index_quote_lines_on_quote_id"
  end

  create_table "quote_vendors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "quote_id"
    t.integer "organization_id"
    t.string "quote_vendor_status"
    t.integer "quote_vendor_created_id"
    t.integer "quote_vendor_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["organization_id"], name: "index_quote_vendors_on_organization_id"
    t.index ["quote_id"], name: "index_quote_vendors_on_quote_id"
  end

  create_table "quotes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "po_header_id"
    t.string "quote_identifier"
    t.string "quote_description"
    t.decimal "quote_total", precision: 25, scale: 10, default: "0.0"
    t.string "quote_status"
    t.text "quote_notes"
    t.boolean "quote_active"
    t.integer "quote_created_id"
    t.integer "quote_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "customer_id"
    t.integer "group_id"
    t.boolean "attachment_public", default: false
    t.integer "user_id"
    t.index ["group_id"], name: "index_quotes_on_group_id"
    t.index ["organization_id"], name: "index_quotes_on_organization_id"
    t.index ["po_header_id"], name: "index_quotes_on_po_header_id"
  end

  create_table "quotes_organizations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "quote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["organization_id"], name: "index_quotes_organizations_on_organization_id"
    t.index ["quote_id"], name: "index_quotes_organizations_on_quote_id"
  end

  create_table "quotes_po_headers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "po_header_id"
    t.integer "quote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["po_header_id"], name: "index_quotes_po_headers_on_po_header_id"
    t.index ["quote_id"], name: "index_quotes_po_headers_on_quote_id"
  end

  create_table "rails_admin_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "message"
    t.string "username"
    t.integer "item"
    t.string "table"
    t.integer "month", limit: 2
    t.bigint "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories"
  end

  create_table "receipt_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "receipt_id"
    t.integer "receivable_id"
    t.decimal "receipt_line_amount", precision: 25, scale: 10, default: "0.0"
    t.integer "receipt_line_created_id"
    t.integer "receipt_line_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["receipt_id"], name: "index_receipt_lines_on_receipt_id"
    t.index ["receivable_id"], name: "index_receipt_lines_on_receivable_id"
  end

  create_table "receipts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "receipt_type_id"
    t.string "receipt_check_code"
    t.decimal "receipt_check_amount", precision: 25, scale: 10, default: "0.0"
    t.string "receipt_check_no"
    t.string "receipt_identifier"
    t.string "receipt_description"
    t.text "receipt_notes"
    t.string "receipt_status"
    t.boolean "receipt_active"
    t.integer "receipt_created_id"
    t.integer "receipt_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "check_entry_id"
    t.integer "deposit_check_id"
    t.decimal "receipt_discount", precision: 25, scale: 10, default: "0.0"
    t.index ["check_entry_id"], name: "index_receipts_on_check_entry_id"
    t.index ["organization_id"], name: "index_receipts_on_organization_id"
  end

  create_table "receivable_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "receivable_id"
    t.integer "gl_account_id"
    t.string "receivable_account_description"
    t.decimal "receivable_account_amount", precision: 25, scale: 10, default: "0.0"
    t.integer "receivable_account_created_id"
    t.integer "receivable_account_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "gl_entry_id"
    t.index ["gl_account_id"], name: "index_receivable_accounts_on_gl_account_id"
    t.index ["receivable_id"], name: "index_receivable_accounts_on_receivable_id"
  end

  create_table "receivable_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "receivable_id"
    t.string "receivable_line_identifier"
    t.string "receivable_line_description"
    t.decimal "receivable_line_cost", precision: 25, scale: 10, default: "0.0"
    t.text "receivable_line_notes"
    t.string "receivable_line_status"
    t.boolean "receivable_line_active"
    t.integer "receivable_line_created_id"
    t.integer "receivable_line_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["receivable_id"], name: "index_receivable_lines_on_receivable_id"
  end

  create_table "receivable_shipments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "receivable_id"
    t.integer "so_line_id"
    t.string "receivable_shipment_identifier"
    t.integer "receivable_shipment_count", default: 0
    t.decimal "receivable_shipment_cost", precision: 25, scale: 10, default: "0.0"
    t.integer "receivable_shipment_created_id"
    t.integer "receivable_shipment_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["receivable_id"], name: "index_receivable_shipments_on_receivable_id"
    t.index ["so_line_id"], name: "index_receivable_shipments_on_so_line_id"
  end

  create_table "receivable_so_shipments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "so_shipment_id"
    t.integer "receivable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["receivable_id"], name: "index_receivable_so_shipments_on_receivable_id"
    t.index ["so_shipment_id"], name: "index_receivable_so_shipments_on_so_shipment_id"
  end

  create_table "receivables", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "so_header_id"
    t.string "receivable_identifier"
    t.string "receivable_description"
    t.decimal "receivable_cost", precision: 25, scale: 10, default: "0.0"
    t.decimal "receivable_discount", precision: 25, scale: 10, default: "0.0"
    t.decimal "receivable_total", precision: 25, scale: 10, default: "0.0"
    t.text "receivable_notes"
    t.string "receivable_status"
    t.boolean "receivable_active"
    t.integer "receivable_created_id"
    t.integer "receivable_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "receivable_invoice"
    t.integer "gl_account_id"
    t.decimal "receivable_freight", precision: 25, scale: 10, default: "0.0"
    t.string "receivable_disperse"
    t.index ["gl_account_id"], name: "index_receivables_on_gl_account_id"
    t.index ["organization_id"], name: "index_receivables_on_organization_id"
    t.index ["so_header_id"], name: "index_receivables_on_so_header_id"
  end

  create_table "reconcileds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reconciles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "reconcile_type"
    t.integer "payment_id"
    t.string "tag"
    t.integer "deposit_check_id"
    t.integer "printing_screen_id"
    t.string "reconcile_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "receipt_id"
    t.index ["deposit_check_id"], name: "index_reconciles_on_deposit_check_id"
    t.index ["payment_id"], name: "index_reconciles_on_payment_id"
    t.index ["printing_screen_id"], name: "index_reconciles_on_printing_screen_id"
  end

  create_table "run_at_rates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "run_at_rate_name"
    t.string "run_at_rate_description"
    t.text "run_at_rate_notes"
    t.boolean "run_at_rate_active"
    t.integer "run_at_rate_created_id"
    t.integer "run_at_rate_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "so_headers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.string "so_identifier"
    t.integer "so_bill_to_id"
    t.integer "so_ship_to_id"
    t.boolean "so_cofc"
    t.boolean "so_squality"
    t.decimal "so_total", precision: 25, scale: 10, default: "0.0"
    t.text "so_notes"
    t.text "so_comments"
    t.string "so_status"
    t.integer "so_created_id"
    t.integer "so_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "so_header_customer_po"
    t.date "so_due_date"
    t.index ["organization_id"], name: "index_so_headers_on_organization_id"
  end

  create_table "so_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "so_header_id"
    t.integer "item_id"
    t.integer "item_revision_id"
    t.integer "item_alt_name_id"
    t.integer "organization_id"
    t.integer "vendor_quality_id"
    t.integer "customer_quality_id"
    t.decimal "so_line_cost", precision: 25, scale: 10, default: "0.0"
    t.decimal "so_line_price", precision: 25, scale: 10, default: "0.0"
    t.integer "so_line_quantity", default: 0
    t.decimal "so_line_freight", precision: 25, scale: 10, default: "0.0"
    t.string "so_line_status"
    t.text "so_line_notes"
    t.boolean "so_line_active"
    t.integer "so_line_created_id"
    t.integer "so_line_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "so_line_shipped", default: 0
    t.decimal "so_line_sell", precision: 25, scale: 10, default: "0.0"
    t.string "so_line_vendor_po"
    t.integer "po_header_id"
    t.string "po"
    t.index ["customer_quality_id"], name: "index_so_lines_on_customer_quality_id"
    t.index ["item_alt_name_id"], name: "index_so_lines_on_item_alt_name_id"
    t.index ["item_id"], name: "index_so_lines_on_item_id"
    t.index ["item_revision_id"], name: "index_so_lines_on_item_revision_id"
    t.index ["organization_id"], name: "index_so_lines_on_organization_id"
    t.index ["so_header_id"], name: "index_so_lines_on_so_header_id"
    t.index ["vendor_quality_id"], name: "index_so_lines_on_vendor_quality_id"
  end

  create_table "so_shipments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "so_line_id"
    t.integer "so_shipped_count", default: 0
    t.decimal "so_shipped_cost", precision: 25, scale: 10, default: "0.0"
    t.string "so_shipped_shelf"
    t.string "so_shipped_unit"
    t.string "so_shipped_status"
    t.integer "so_shipment_created_id"
    t.integer "so_shipment_updated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "quality_lot_id", default: 0
    t.integer "so_header_id"
    t.string "shipment_process_id"
    t.index ["so_line_id"], name: "index_so_shipments_on_so_line_id"
  end

  create_table "specifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "specification_active"
    t.string "specification_identifier"
    t.string "specification_description"
    t.text "specification_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "revision"
    t.date "revision_date"
  end

  create_table "taggings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "territories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "territory_active"
    t.string "territory_identifier"
    t.string "territory_description"
    t.string "territory_zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "test_package_id"
    t.string "item_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["test_package_id"], name: "index_test_items_on_test_package_id"
  end

  create_table "test_packages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "name", null: false
    t.string "gender"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "telephone_no"
    t.string "mobile_no"
    t.string "fax"
    t.boolean "active", default: true
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.integer "roles_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "organization_id"
    t.string "time_zone", default: "Eastern Time (US & Canada)"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "vendor_qualities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "quality_name"
    t.string "quality_description"
    t.text "quality_notes"
    t.boolean "quality_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
