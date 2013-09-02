class QualityLot < ActiveRecord::Base
	belongs_to :po_header
	belongs_to :po_line
	belongs_to :item_revision
	belongs_to :fmea_type
	belongs_to :control_plan
	belongs_to :process_flow

	before_save :before_save_values

	def before_save_values
		
	end

  	attr_accessible :po_header_id, :po_line_id, :item_revision_id, :inspection_level_id, :inspection_method_id, 
  	:inspection_type_id, :lot_active, :lot_control_no, :lot_created_id, :lot_finalized_at, :lot_inspector_id, 
  	:lot_notes, :lot_quantity, :lot_updated_id, :lot_aql_no, :fmea_type_id, :control_plan_id, :process_flow_id

   	belongs_to :inspection_level, :class_name => "MasterType", :foreign_key => "inspection_level_id", 
	:conditions => ['type_category = ?', 'inspection_level']

	belongs_to :inspection_method, :class_name => "MasterType", :foreign_key => "inspection_method_id", 
	:conditions => ['type_category = ?', 'inspection_method']

	belongs_to :inspection_type, :class_name => "MasterType", :foreign_key => "inspection_type_id", 
	:conditions => ['type_category = ?', 'inspection_type']

	belongs_to :lot_inspector, :class_name => "User", :foreign_key => "lot_inspector_id"

	validates_presence_of :po_line, :item_revision, :fmea_type, :control_plan, :process_flow, :lot_quantity
end
