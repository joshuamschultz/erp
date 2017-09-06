unless User.find_by_email('joshua@alliance.com')
  user = User.new(email: 'joshua@alliance.com', name: 'Erin', password: '12345678', password_confirmation: '12345678')
  user.roles = [:superadmin]
  user.save
end

mastertypes = [
  # Commission Types
  ['All', 'Sell * Quantity Shipped', 'all', 'commission_type', 'true'],
  ['Profit', '[Sell - Cost] * Quantity Shipped', 'profit', 'commission_type', 'true'],
  # Contact Types
  ['Email', '', 'email', 'customer_contact_type', 'true'],
  ['Fax', '', 'fax', 'customer_contact_type', 'true'],
  # Organization Types
  ['Customer', '', 'customer', 'organization_type', 'true'],
  ['Vendor', '', 'vendor', 'organization_type', 'true'],
  ['Support', '', 'support', 'organization_type', 'true'],
  # PO Types
  ['Regular', '', 'regular', 'po_type', 'true'],
  ['Transfer', '', 'transer', 'po_type', 'true'],
  ['Direct', '', 'direct', 'po_type', 'true'],
  # Customer Quality Level
  ['APQP Information', '', 'apqp_information', 'customer_quality_level', 'true'],
  ['APQP Timing', '', 'apqp_timing', 'customer_quality_level', 'true'],
  ['Design Records', '', 'design_records', 'customer_quality_level', 'true'],
  ['Engineering Change', '', 'engineering_change', 'customer_quality_level', 'true'],
  ['Engineering Approval', '', 'engineering_approval', 'customer_quality_level', 'true'],
  ['DFMEA', '', 'dfmea', 'customer_quality_level', 'true'],
  ['Process Flow Diagram', '', 'process_flow_diagram', 'customer_quality_level', 'true'],
  ['PFMEA', '', 'pfmea', 'customer_quality_level', 'true'],
  ['Control Plan', '', 'control_plan', 'customer_quality_level', 'true'],
  ['Material Inspection', '', 'material_inspection', 'customer_quality_level', 'true'],
  ['Dimensional Inspection', '', 'dimensional_inspection', 'customer_quality_level', 'true'],
  ['Mold Design Checklist', '', 'mold_design_checklist', 'customer_quality_level', 'true'],
  ['Gage R&R', '', 'gage_r&r', 'customer_quality_level', 'true'],
  ['Capability Studies', '', 'capability_studies', 'customer_quality_level', 'true'],
  ['Capability Analysis', '', 'capability_analysis', 'customer_quality_level', 'true'],
  ['Gage Review', '', 'gage_review', 'customer_quality_level', 'true'],
  ['Run at Rate', '', 'run_at_rate', 'customer_quality_level', 'true'],
  ['Qualified Laboratory Docs', '', 'qualified_laboratory_docs', 'customer_quality_level', 'true'],
  ['Sample Production Parts', '', 'sample_production_parts', 'customer_quality_level', 'true'],
  ['Master Sample', '', 'master_sample', 'customer_quality_level', 'true'],
  ['Packaging', '', 'packaging', 'customer_quality_level', 'true'],
  ['Part Submission Warrant (PSW)', '', 'part_submission_warrant_psw', 'customer_quality_level', 'true'],
  ['CofC', '', 'cofc', 'customer_quality_level', 'true'],
  ['Parker Form 35', '', 'parker_form_35', 'customer_quality_level', 'true'],
  ['Parker Form 36', '', 'parker_form_36', 'customer_quality_level', 'true'],
  ['Textron Cof C', '', 'textron_cof_c', 'customer_quality_level', 'true'],
  ['Goodrich Release Check', '', 'goodrich_release_check', 'customer_quality_level', 'true'],
  # Inspection level
  ['Level 1', '', 'level_1', 'inspection_level', 'true'],
  ['Level 2', '', 'level_2', 'inspection_level', 'true'],
  ['Level 3', '', 'level_3', 'inspection_level', 'true'],
  # Inspection method
  ['Single', '', 'single', 'inspection_method', 'true'],
  ['Double', '', 'double', 'inspection_method', 'true'],
  ['Multiple', '', 'multiple', 'inspection_method', 'true'],
  # Inspection Type
  ['Normal', '', 'normal', 'inspection_type', 'true'],
  ['Reduced', '', 'reduced', 'inspection_type', 'true'],
  ['Tightened', '', 'tightened', 'inspection_type', 'true'],
  # Payment Types
  ['Cash', '', 'cash', 'payment_type', 'true'],
  ['Check', '', 'check', 'payment_type', 'true'],
  ['Credit', '', 'credit', 'payment_type', 'true'],
  ['ACH', '', 'ach', 'payment_type', 'true'],
  # GL Modes
  %w[Credit Credit C gl_mode true],
  %w[Debit Debit D gl_mode true],
  # GL Categories
  %w[Balance Balance B gl_category true],
  %w[Trial Trial T gl_category true],
  # Org Type for Quality Action
  ['Customer', '', 'customer_q_a', 'organization_type_q_a', 'true'],
  ['Vendor', '', 'vendor_q_a', 'organization_type_q_a', 'true'],
  ['Internal', '', 'internal_q_a', 'organization_type_q_a', 'true'],
  # ICP For Quality Action
  ['Corrective', '', 'corrective', 'icp_quallity_action', 'true'],
  ['Preventive', '', 'preventive', 'icp_quallity_action', 'true'],
  # Customer Response
  ['Complaint', '', 'complaint', 'customer_response', 'true'],
  ['Suggestion', '', 'suggestion', 'customer_response', 'true'],
  ['Praise', '', 'praise', 'customer_response', 'true']
]

mastertypes.each do |master|
  unless MasterType.find_by_type_value(master[2])
    MasterType.create(type_name: master[0], type_description: master[1], type_value: master[2], type_category: master[3], type_active: master[4])
  end
end

# GL Types & Categories
# FastSeeder.seed_csv!(GlType, "gl_types.csv", :gl_name, :gl_side, :gl_report, :gl_identifier)
# FastSeeder.seed_csv!(GlAccount,"gl_accounts.csv", :gl_type_id, :gl_account_title, :gl_account_identifier)
# GlAccount.all.each do |account|
#  account.update_attributes(:key_account => true, :gl_account_active => true)
# end

check_codes = [
  %w[400 check_code],
  %w[100 quality_next]
]

check_codes.each do |ch|
  unless CheckCode.find_by_counter_type(ch[1])
    CheckCode.create(counter: ch[0], counter_type: ch[1])
  end
end

# Organization.create!([
#   {user_id: nil, organization_type_id: 5, territory_id: 1, customer_quality_id: 2, customer_contact_type_id: 3, customer_max_quality_id: nil, vendor_quality_id: 1, vendor_expiration_date: "2016-01-29", organization_name: "Remington Firearms", organization_short_name: "Remington", organization_description: "Home Office - Illian", organization_address_1: "Illion Way", organization_address_2: "", organization_city: "Illion", organization_state: "NY", organization_country: "United States", organization_zipcode: "13908", organization_telephone: "315.098.4503", organization_fax: "", organization_email: "dutchconsumer@gmail.com", organization_website: "www.remington.com", organization_notes: "", organization_active: true, organization_created_id: nil, organization_updated_id: nil, customer_min_quality_id: 3, organization_complete: true},
#   {user_id: nil, organization_type_id: 6, territory_id: 2, customer_quality_id: 1, customer_contact_type_id: 3, customer_max_quality_id: nil, vendor_quality_id: 2, vendor_expiration_date: "2016-01-03", organization_name: "Cashi Components", organization_short_name: "Cashi", organization_description: "Taiwan Office", organization_address_1: "7383 Taiwan Drive", organization_address_2: "", organization_city: "Tapai City", organization_state: "HL", organization_country: "Taiwan, Republic Of China", organization_zipcode: "786533", organization_telephone: "", organization_fax: "", organization_email: "dutchconsumer@gmail.com", organization_website: "", organization_notes: "", organization_active: true, organization_created_id: nil, organization_updated_id: nil, customer_min_quality_id: 1, organization_complete: false},
#   {user_id: nil, organization_type_id: 6, territory_id: nil, customer_quality_id: 1, customer_contact_type_id: 3, customer_max_quality_id: nil, vendor_quality_id: 2, vendor_expiration_date: "2016-01-04", organization_name: "American Pride", organization_short_name: "Home Office", organization_description: "Dirtbags in everything", organization_address_1: "", organization_address_2: "", organization_city: "", organization_state: "", organization_country: "United States", organization_zipcode: "", organization_telephone: "", organization_fax: "", organization_email: "dutchconsumer@gmail.com", organization_website: "www.google.com", organization_notes: "", organization_active: true, organization_created_id: nil, organization_updated_id: nil, customer_min_quality_id: 1, organization_complete: false},
#   {user_id: nil, organization_type_id: 7, territory_id: nil, customer_quality_id: 1, customer_contact_type_id: 3, customer_max_quality_id: nil, vendor_quality_id: 1, vendor_expiration_date: "2016-01-29", organization_name: "Cal-Vibration", organization_short_name: "Calation", organization_description: "Calibrators", organization_address_1: "", organization_address_2: "", organization_city: "", organization_state: "", organization_country: "United States", organization_zipcode: "", organization_telephone: "", organization_fax: "", organization_email: "dutch@chessgroupinc.com", organization_website: "", organization_notes: "", organization_active: true, organization_created_id: nil, organization_updated_id: nil, customer_min_quality_id: 1, organization_complete: false},
#   {user_id: nil, organization_type_id: 5, territory_id: 1, customer_quality_id: 2, customer_contact_type_id: 3, customer_max_quality_id: nil, vendor_quality_id: 1, vendor_expiration_date: "2016-01-27", organization_name: "Ephesus Lighting", organization_short_name: "Ephesus", organization_description: "Home Office", organization_address_1: "76 jefferson street", organization_address_2: "", organization_city: "Syracuse", organization_state: "NY", organization_country: "United States", organization_zipcode: "130089", organization_telephone: "", organization_fax: "", organization_email: "dutch@chessgroupinc.com", organization_website: "", organization_notes: "", organization_active: true, organization_created_id: nil, organization_updated_id: nil, customer_min_quality_id: 3, organization_complete: false}
# ])
unless Owner.find_by_owner_identifier('Chess Group Inc')
  Owner.create!([
                  { owner_identifier: 'Chess Group Inc', owner_description: '', owner_commission_type_id: 1, owner_commission_amount: '5.0', owner_active: true }
                ])
end

unless CompanyInfo.find_by_company_name('Chess Group Inc')
  CompanyInfo.create!([
                        { company_name: 'Chess Group Inc', company_address1: '7010 Fly Road', company_address2: 'East Syracuse, NY 13057', company_phone1: '315.200.1037', company_phone2: nil, company_mobile: nil, company_fax: '315.432.0899', company_website: 'www.chessgroupinc.com', company_slogan: 'Always One Step Ahead', company_active: nil }
                      ])
end

unless Element.count > 0
  elements = ActiveSupport::JSON.decode(File.read('db/seeds/elements.json'))

  elements.each do |element|
    Element.create!(element_active: true, element_name: element['name'], element_symbol: element['symbol'])
  end
end

#
# Contact.create!([
#   {contactable_id: 1, contactable_type: "Organization", contact_type: "address", contact_title: "Remington Firearms", contact_description: "Home Office - Illian", contact_address_1: "Illion Way", contact_address_2: "", contact_city: "Illion", contact_state: "NY", contact_country: "United States", contact_zipcode: "13908", contact_telephone: "315.098.4503", contact_fax: "", contact_email: "dutchconsumer@gmail.com", contact_website: "www.remington.com", contact_notes: "", contact_active: true, contact_created_id: nil, contact_updated_id: nil, first_name: nil, last_name: nil},
#   {contactable_id: 1, contactable_type: "Organization", contact_type: "address", contact_title: "Main Factory", contact_description: "Huntsville Shipping", contact_address_1: "6480 Remington Way", contact_address_2: "", contact_city: "Huntsville", contact_state: "AL", contact_country: "United States", contact_zipcode: "87643", contact_telephone: "456.555.4564", contact_fax: "", contact_email: "dutch@chessgroupinc.com", contact_website: "remington.com", contact_notes: "", contact_active: true, contact_created_id: nil, contact_updated_id: nil, first_name: nil, last_name: nil},
#   {contactable_id: 3, contactable_type: "Organization", contact_type: "address", contact_title: "American Pride", contact_description: "Dirtbags in everything", contact_address_1: "", contact_address_2: "", contact_city: "", contact_state: "", contact_country: "United States", contact_zipcode: "", contact_telephone: "", contact_fax: "", contact_email: "dutchconsumer@gmail.com", contact_website: "www.google.com", contact_notes: "", contact_active: true, contact_created_id: nil, contact_updated_id: nil, first_name: nil, last_name: nil},
#   {contactable_id: 4, contactable_type: "Organization", contact_type: "address", contact_title: "Cal-Vibration", contact_description: "Calibrators", contact_address_1: "", contact_address_2: "", contact_city: "", contact_state: "", contact_country: "United States", contact_zipcode: "", contact_telephone: "", contact_fax: "", contact_email: "dutch@chessgroupinc.com", contact_website: "", contact_notes: "", contact_active: true, contact_created_id: nil, contact_updated_id: nil, first_name: nil, last_name: nil},
#   {contactable_id: 5, contactable_type: "Organization", contact_type: "address", contact_title: "Ephesus Lighting", contact_description: "Home Office", contact_address_1: "", contact_address_2: "", contact_city: "", contact_state: "", contact_country: "United States", contact_zipcode: "", contact_telephone: "", contact_fax: "", contact_email: "dutch@chessgroupinc.com", contact_website: "", contact_notes: "", contact_active: true, contact_created_id: nil, contact_updated_id: nil, first_name: nil, last_name: nil},
#   {contactable_id: 5, contactable_type: "Organization", contact_type: "address", contact_title: "Ansen", contact_description: "Ansen Manufacturing Center", contact_address_1: "7849 Hollywood Way", contact_address_2: "", contact_city: "Ogdensburg", contact_state: "NY", contact_country: "United States", contact_zipcode: "13098", contact_telephone: "", contact_fax: "", contact_email: "dutchconsumer@gmail.com", contact_website: "", contact_notes: "", contact_active: true, contact_created_id: nil, contact_updated_id: nil, first_name: nil, last_name: nil}
# ])
#
# CustomerQuality.create!([
#   {quality_name: "Visual", quality_description: "", quality_notes: "", quality_active: true, quality_created_id: nil, quality_updated_id: nil, quality_supplier_a: nil, quality_supplier_b: nil, quality_floor_plan: nil, quality_form: nil, quality_packaging: nil, quality_psw: nil, quality_control_plan: nil, quality_fmea: nil, quality_process_flow: nil, quality_gauge: nil, quality_study: nil, quality_dimensional_cofc: nil, quality_material_cofc: nil},
#   {quality_name: "FAI", quality_description: "", quality_notes: "", quality_active: true, quality_created_id: nil, quality_updated_id: nil, quality_supplier_a: nil, quality_supplier_b: nil, quality_floor_plan: nil, quality_form: nil, quality_packaging: nil, quality_psw: nil, quality_control_plan: nil, quality_fmea: nil, quality_process_flow: nil, quality_gauge: nil, quality_study: nil, quality_dimensional_cofc: nil, quality_material_cofc: nil},
#   {quality_name: "PPAP", quality_description: "", quality_notes: "", quality_active: true, quality_created_id: nil, quality_updated_id: nil, quality_supplier_a: nil, quality_supplier_b: nil, quality_floor_plan: nil, quality_form: nil, quality_packaging: nil, quality_psw: nil, quality_control_plan: nil, quality_fmea: nil, quality_process_flow: nil, quality_gauge: nil, quality_study: nil, quality_dimensional_cofc: nil, quality_material_cofc: nil}
# ])
# CustomerQualityLevel.create!([
#   {customer_quality_id: 1, master_type_id: 33},
#   {customer_quality_id: 2, master_type_id: 13},
#   {customer_quality_id: 2, master_type_id: 21},
#   {customer_quality_id: 3, master_type_id: 13},
#   {customer_quality_id: 3, master_type_id: 17},
#   {customer_quality_id: 3, master_type_id: 18},
#   {customer_quality_id: 3, master_type_id: 19},
#   {customer_quality_id: 3, master_type_id: 20},
#   {customer_quality_id: 3, master_type_id: 23},
#   {customer_quality_id: 3, master_type_id: 27},
#   {customer_quality_id: 3, master_type_id: 31}
# ])
#
# Dimension.create!([
#   {dimension_identifier: "Length", dimension_description: "", dimension_notes: "", dimension_active: true, dimension_created_id: nil, dimension_updated_id: nil},
#   {dimension_identifier: "Diameter", dimension_description: "", dimension_notes: "", dimension_active: true, dimension_created_id: nil, dimension_updated_id: nil},
#   {dimension_identifier: "Across the Flats", dimension_description: "", dimension_notes: "", dimension_active: true, dimension_created_id: nil, dimension_updated_id: nil},
#   {dimension_identifier: "Thread", dimension_description: "", dimension_notes: "", dimension_active: true, dimension_created_id: nil, dimension_updated_id: nil}
# ])
#
#
#
# Element.create!([
#   {element_name: "Carbon", element_symbol: "C", element_notes: "", element_created_id: nil, element_updated_id: nil, element_active: true},
#   {element_name: "Silicon", element_symbol: "Si", element_notes: "", element_created_id: nil, element_updated_id: nil, element_active: true},
#   {element_name: "Lead", element_symbol: "Pb", element_notes: "", element_created_id: nil, element_updated_id: nil, element_active: true},
#   {element_name: "Sulfur", element_symbol: "S", element_notes: "", element_created_id: nil, element_updated_id: nil, element_active: true},
#   {element_name: "Phosphorus", element_symbol: "P", element_notes: "", element_created_id: nil, element_updated_id: nil, element_active: true},
#   {element_name: "Nickel", element_symbol: "Ni", element_notes: "", element_created_id: nil, element_updated_id: nil, element_active: true}
# ])
# Gauge.create!([
#   {organization_id: nil, gauge_tool_name: "0 - 6 Caliper", gauge_tool_category: "Caliper", gauge_tool_no: "7a8sd9f0asdf", gage_caliberation_last_at: "2015-10-06", gage_caliberation_due_at: "2016-07-08", gage_caliberaion_period: nil, gauge_active: true, gauge_created_id: nil, gauge_updated_id: nil},
#   {organization_id: nil, gauge_tool_name: "CMM", gauge_tool_category: "CMM", gauge_tool_no: "a87dsfa9s0df", gage_caliberation_last_at: "2016-01-29", gage_caliberation_due_at: "2016-07-08", gage_caliberaion_period: nil, gauge_active: true, gauge_created_id: nil, gauge_updated_id: nil},
#   {organization_id: nil, gauge_tool_name: "Micrometer Smaler", gauge_tool_category: "Micrometer", gauge_tool_no: "as7d8fads9f0ad", gage_caliberation_last_at: "2015-05-04", gage_caliberation_due_at: "2016-02-03", gage_caliberaion_period: nil, gauge_active: true, gauge_created_id: nil, gauge_updated_id: nil}
# ])
#
# Image.create!([
#   {imageable_id: 1, imageable_type: "CompanyInfo", image_title: nil, image_description: nil, image_notes: nil, image_file_name: "smaller_logo.png", image_file_size: "18276", image_content_type: "image/png", image_public: nil, image_active: nil, image_created_id: nil, image_updated_id: nil}
# ])
# Item.create!([
#   {item_part_no: "H-054", item_quantity_on_order: nil, item_quantity_in_hand: nil, item_active: true, item_created_id: nil, item_updated_id: nil, item_alt_part_no: "64857-1K-060"},
#   {item_part_no: "STD-333", item_quantity_on_order: nil, item_quantity_in_hand: nil, item_active: true, item_created_id: nil, item_updated_id: nil, item_alt_part_no: "WHS8766"}
# ])
#
# ItemPartDimension.create!([
#   {dimension_id: 3, gauge_id: 1, item_part_letter: "01", item_part_dimension: "4.0", item_part_pos_tolerance: "0.05", item_part_neg_tolerance: "0.05", item_part_critical: false, item_part_notes: nil, item_part_active: true, item_part_created_id: nil, item_part_updated_id: nil, go_non_go: false, dimension_string: "4"},
#   {dimension_id: 1, gauge_id: 1, item_part_letter: "02", item_part_dimension: "1.3", item_part_pos_tolerance: "0.01", item_part_neg_tolerance: "0.01", item_part_critical: true, item_part_notes: nil, item_part_active: true, item_part_created_id: nil, item_part_updated_id: nil, go_non_go: false, dimension_string: "1.3"},
#   {dimension_id: 4, gauge_id: 1, item_part_letter: "01", item_part_dimension: "0.0", item_part_pos_tolerance: "0.0", item_part_neg_tolerance: "0.0", item_part_critical: false, item_part_notes: nil, item_part_active: true, item_part_created_id: nil, item_part_updated_id: nil, go_non_go: true, dimension_string: "8"},
#   {dimension_id: 1, gauge_id: 1, item_part_letter: "01", item_part_dimension: "1.2", item_part_pos_tolerance: "0.004", item_part_neg_tolerance: "0.005", item_part_critical: false, item_part_notes: nil, item_part_active: true, item_part_created_id: nil, item_part_updated_id: nil, go_non_go: false, dimension_string: "1.2"}
# ])
#
# ItemRevision.create!([
#   {item_revision_name: "B", item_revision_date: "2016-01-03", item_id: 1, owner_id: 1, organization_id: 1, vendor_quality_id: nil, customer_quality_id: nil, item_name: "Screw", item_description: "1/2 Crazy Nut", item_notes: "", item_tooling: "0.0", item_cost: "0.0", item_revision_created_id: nil, item_revision_updated_id: nil, print_id: 1, material_id: 1, latest_revision: true, item_revision_complete: true, item_sell: nil},
#   {item_revision_name: "F", item_revision_date: "2016-01-03", item_id: 2, owner_id: 1, organization_id: 1, vendor_quality_id: nil, customer_quality_id: nil, item_name: "Washer", item_description: "Steel Washer with 0167\" Diamter", item_notes: "", item_tooling: "0.0", item_cost: "0.0", item_revision_created_id: nil, item_revision_updated_id: nil, print_id: 2, material_id: 2, latest_revision: true, item_revision_complete: true, item_sell: nil}
# ])
#
# ItemProcess.create!([
#   {item_revision_id: 1, process_type_id: 2},
#   {item_revision_id: 2, process_type_id: 1}
# ])
#
# MaterialElement.create!([
#   {material_id: 1, element_id: 1, element_symbol: nil, element_name: nil, element_low_range: "4.0", element_high_range: "7.0", element_active: true, element_created_id: nil, element_updated_id: nil},
#   {material_id: 1, element_id: 3, element_symbol: nil, element_name: nil, element_low_range: "0.05", element_high_range: "0.09", element_active: true, element_created_id: nil, element_updated_id: nil},
#   {material_id: 1, element_id: 6, element_symbol: nil, element_name: nil, element_low_range: "2.0", element_high_range: "4.0", element_active: true, element_created_id: nil, element_updated_id: nil},
#   {material_id: 2, element_id: 1, element_symbol: nil, element_name: nil, element_low_range: "4.0", element_high_range: "7.0", element_active: true, element_created_id: nil, element_updated_id: nil},
#   {material_id: 2, element_id: 3, element_symbol: nil, element_name: nil, element_low_range: "4.0", element_high_range: "5.0", element_active: true, element_created_id: nil, element_updated_id: nil},
#   {material_id: 2, element_id: 6, element_symbol: nil, element_name: nil, element_low_range: "2.0", element_high_range: "4.0", element_active: true, element_created_id: nil, element_updated_id: nil},
#   {material_id: 2, element_id: 4, element_symbol: nil, element_name: nil, element_low_range: "1.0", element_high_range: "2.0", element_active: true, element_created_id: nil, element_updated_id: nil}
# ])
# Material.create!([
#   {material_short_name: "AISI 7876", material_description: "Carbon Steel Low Lead", material_notes: "", material_created_id: nil, material_updated_id: nil, material_active: true},
#   {material_short_name: "AISI 4576", material_description: "Carbon Steel High Lead", material_notes: "", material_created_id: nil, material_updated_id: nil, material_active: true}
# ])
#
# VendorQuality.create!([
#   {quality_name: "A", quality_description: "ISO and AS", quality_notes: "", quality_active: true, quality_created_id: nil, quality_updated_id: nil},
#   {quality_name: "B", quality_description: "ISO", quality_notes: "", quality_active: true, quality_created_id: nil, quality_updated_id: nil},
#   {quality_name: "C", quality_description: "Needed but ISO or AS", quality_notes: "", quality_active: true, quality_created_id: nil, quality_updated_id: nil},
#   {quality_name: "D", quality_description: "Not Aerospace Appropriate", quality_notes: "", quality_active: true, quality_created_id: nil, quality_updated_id: nil}
# ])
# ItemRevisionItemPartDimension.create!([
#   {item_revision_id: 1, item_part_dimension_id: 1},
#   {item_revision_id: 1, item_part_dimension_id: 2},
#   {item_revision_id: 2, item_part_dimension_id: 3},
#   {item_revision_id: 2, item_part_dimension_id: 4}
# ])
# ProcessTypeSpecification.create!([
#   {process_type_id: 2, specification_id: 1}
# ])
