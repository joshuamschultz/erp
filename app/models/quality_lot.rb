class QualityLot < ActiveRecord::Base
	belongs_to :po_header
	belongs_to :po_line
	belongs_to :item_revision
	belongs_to :fmea_type
	belongs_to :control_plan
	belongs_to :process_flow

	after_create :after_create_values

	def after_create_values
		self.lot_control_no = self.set_lot_control_no
		self.save(:validate => false)
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

	has_many :comments, :as => :commentable, :dependent => :destroy

	validates_presence_of :po_header, :po_line, :item_revision, :lot_quantity, :item_revision_id, :po_line_id
	#, :fmea_type, :control_plan, :process_flow, 

	validate :check_lot_quantity

	def check_lot_quantity
		lot_total_quantity = self.po_line.quality_lots.where("id != ?", self.id).sum(:lot_quantity)
		if (lot_total_quantity + self.lot_quantity) > self.po_line.po_line_quantity
			errors.add(:lot_quantity, "exceeded than PO item quantity (#{self.po_line.po_line_quantity})")
		end
		# errors.add(:lot_quantity, " #{lot_total_quantity},  #{self.lot_quantity},  #{self.po_line.po_line_quantity})")
	end

	def set_lot_control_no
		"%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + 
		CommonActions.current_hour_letter + Time.now.min.to_s + "-" + self.id.to_s
	end

end
