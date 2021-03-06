# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.find_by_email('joshua@alliance.com')
   user = User.new(email: 'joshua@alliance.com', name: 'joshua', password: '12345678', password_confirmation: '12345678')
   user.roles = [:superadmin]
   user.save
end

mastertypes = [
   # Commission Types
   ["All", "Sell * Quantity Shipped", "all", "commission_type", "true"],
   ["Profit", "[Sell - Cost] * Quantity Shipped", "profit", "commission_type", "true"],
   # Contact Types
   ["Email", "", "email" ,"customer_contact_type", "true"],
   ["Fax", "", "fax", "customer_contact_type", "true"],
   # Organization Types
   ["Customer", "", "customer", "organization_type", "true"],
   ["Vendor", "", "vendor", "organization_type", "true"],
   ["Support", "", "support", "organization_type", "true"],
   # PO Types
   ["Regular", "", "regular", "po_type", "true"],
   ["Transfer", "", "transer", "po_type", "true"],
   ["Direct", "", "direct", "po_type", "true"],
   #Customer Quality Level
   ["APQP Information", "", "apqp_information", "customer_quality_level", "true"],
   ["APQP Timing", "", "apqp_timing", "customer_quality_level", "true"],
   ["Design Records", "", "design_records", "customer_quality_level", "true"],
   ["Engineering Change", "", "engineering_change", "customer_quality_level", "true"],
   ["Engineering Approval", "", "engineering_approval", "customer_quality_level", "true"],
   ["DFMEA", "", "dfmea", "customer_quality_level", "true"],
   ["Process Flow Diagram", "", "process_flow_diagram", "customer_quality_level", "true"],
   ["PFMEA", "", "pfmea", "customer_quality_level", "true"],
   ["Control Plan", "", "control_plan", "customer_quality_level", "true"],
   ["Material Inspection", "", "material_inspection", "customer_quality_level", "true"],
   ["Dimensional Inspection", "", "dimensional_inspection", "customer_quality_level", "true"],
   ["Mold Design Checklist", "", "mold_design_checklist", "customer_quality_level", "true"],
   ["Gage R&R", "", "gage_r&r", "customer_quality_level", "true"],
   ["Capability Studies", "", "capability_studies", "customer_quality_level", "true"],
   ["Capability Analysis", "", "capability_analysis", "customer_quality_level", "true"],
   ["Gage Review", "", "gage_review", "customer_quality_level", "true"],
   ["Run at Rate", "", "run_at_rate", "customer_quality_level", "true"],
   ["Qualified Laboratory Docs", "", "qualified_laboratory_docs", "customer_quality_level", "true"],
   ["Sample Production Parts", "", "sample_production_parts", "customer_quality_level", "true"],
   ["Master Sample", "", "master_sample", "customer_quality_level", "true"],
   ["Packaging", "", "packaging", "customer_quality_level", "true"],
   ["Part Submission Warrant (PSW)", "", "part_submission_warrant_psw", "customer_quality_level", "true"],
   ["CofC", "", "cofc", "customer_quality_level", "true"],
   ["Parker Form 35", "", "parker_form_35", "customer_quality_level", "true"],
   ["Parker Form 36", "", "parker_form_36", "customer_quality_level", "true"],
   ["Textron Cof C", "", "textron_cof_c", "customer_quality_level", "true"],
   ["Goodrich Release Check", "", "goodrich_release_check", "customer_quality_level", "true"],
   # Inspection level
   ["Level 1" ,"" ,"level_1" , "inspection_level", "true"],
   ["Level 2" ,"" ,"level_2" , "inspection_level", "true"],
   ["Level 3" ,"" ,"level_3" , "inspection_level", "true"],
   # Inspection method
   ["Single", "", "single", "inspection_method", "true"],
   ["Double", "", "double", "inspection_method", "true"],
   ["Multiple", "", "multiple", "inspection_method", "true"],
   # Inspection Type
   ["Normal", "", "normal", "inspection_type", "true"],
   ["Reduced", "", "reduced", "inspection_type", "true"],
   ["Tightened", "", "tightened", "inspection_type", "true"],
   #Payment Types
   ["Cash", "", "cash", "payment_type", "true"],
   ["Check", "", "check", "payment_type", "true"],
   ["Credit", "", "credit", "payment_type", "true"],
   ["ACH", "", "ach", "payment_type", "true"],
   # GL Modes
   ["Credit", "Credit", "C", "gl_mode", "true"],
   ["Debit", "Debit", "D", "gl_mode", "true"],
   # GL Categories
   ["Balance", "Balance", "B", "gl_category", "true"],
   ["Trial", "Trial", "T", "gl_category", "true"],
   # Org Type for Quality Action
   ["Customer", "", "customer_q_a", "organization_type_q_a", "true"],
   ["Vendor", "", "vendor_q_a", "organization_type_q_a", "true"],
   ["Internal", "", "internal_q_a", "organization_type_q_a", "true"],
   # ICP For Quality Action
   ["Corrective", "", "corrective", "icp_quallity_action", "true"],
   ["Preventive", "", "preventive", "icp_quallity_action", "true"],
   # Customer Response
   ["Complaint", "", "complaint", "customer_response", "true"],
   ["Suggestion", "", "suggestion", "customer_response", "true"],
   ["Praise", "", "praise", "customer_response", "true"],
]

mastertypes.each do |master|
   unless MasterType.find_by_type_value(master[2])
      MasterType.create(:type_name => master[0], :type_description => master[1], :type_value => master[2], :type_category => master[3], :type_active => master[4])
   end
end

# GL Types & Categories
FastSeeder.seed_csv!(GlType, "gl_types.csv", :gl_name, :gl_side, :gl_report, :gl_identifier)
FastSeeder.seed_csv!(GlAccount,"gl_accounts.csv", :gl_type_id, :gl_account_title, :gl_account_identifier)
GlAccount.all.each do |account|
  account.update_attributes(:key_account => true, :gl_account_active => true)
end


check_codes = [
   ["", "check_code"],
   ["", "quality_next"],
]

check_codes.each do |ch|
   unless CheckCode.find_by_counter_type(ch[1])
      CheckCode.create(:counter => ch[0], :counter_type => ch[1])
   end
end