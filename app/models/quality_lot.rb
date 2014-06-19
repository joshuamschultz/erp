class QualityLot < ActiveRecord::Base
	include Rails.application.routes.url_helpers
	
	belongs_to :po_header
	belongs_to :po_line
	belongs_to :item_revision
	belongs_to :fmea_type
	belongs_to :control_plan
	belongs_to :process_flow
	belongs_to :run_at_rate

	before_create :before_create_values

	def before_create_values
		self.lot_control_no = self.set_lot_control_no
	end

  	attr_accessible :po_header_id, :po_line_id, :item_revision_id, :inspection_level_id, :inspection_method_id, 
  	:inspection_type_id, :lot_active, :lot_control_no, :lot_created_id, :lot_finalized_at, :lot_inspector_id, 
  	:lot_notes, :lot_quantity, :lot_updated_id, :lot_aql_no, :fmea_type_id, :control_plan_id, :process_flow_id,
  	:lot_shelf_idenifier, :lot_shelf_unit, :lot_shelf_number, :quality_lot_materials_attributes, :run_at_rate_id,
  	:fai

   	belongs_to :inspection_level, :class_name => "MasterType", :foreign_key => "inspection_level_id", 
	:conditions => ['type_category = ?', 'inspection_level']

	belongs_to :inspection_method, :class_name => "MasterType", :foreign_key => "inspection_method_id", 
	:conditions => ['type_category = ?', 'inspection_method']

	belongs_to :inspection_type, :class_name => "MasterType", :foreign_key => "inspection_type_id", 
	:conditions => ['type_category = ?', 'inspection_type']

	belongs_to :lot_inspector, :class_name => "User", :foreign_key => "lot_inspector_id"

	has_many :comments, :as => :commentable, :dependent => :destroy
	has_many :quality_lot_materials, :dependent => :destroy
	has_many :quality_lot_dimensions, :dependent => :destroy
	has_many :quality_lot_capabilities, :dependent => :destroy
	has_many :quality_lot_gauges, :dependent => :destroy
	has_many :attachments, :as => :attachable, :dependent => :destroy
	has_one :package, :dependent => :destroy
	has_one :checklist, :dependent => :destroy
	has_one :ppap, :dependent => :destroy

	accepts_nested_attributes_for :quality_lot_materials, :reject_if => lambda { |b| b[:lot_element_low_range].blank? }

	validates_presence_of :po_header, :po_line, :item_revision, :lot_quantity, :item_revision_id, :po_line_id
	#, :fmea_type, :control_plan, :process_flow, 

	after_save :create_checklist

	def create_checklist
		unless self.checklist.present?
			checklist = Checklist.create(:quality_lot_id => self.id, :po_line_id => self.po_line.id, :customer_quality_id => self.get_quality_level.id)		
			if checklist
				self.get_quality_level.customer_quality_levels.each do |quality_level|
					CheckListLine.create(:checklist_id => checklist.id, :master_type_id => quality_level.master_type_id, :check_list_status => false)		
				end
			end
		else			
			self.checklist.destroy
			checklist = Checklist.create(:quality_lot_id => self.id, :po_line_id => self.po_line.id, :customer_quality_id => self.get_quality_level.id)		
			if checklist
				self.get_quality_level.customer_quality_levels.each do |quality_level|
					CheckListLine.create(:checklist_id => checklist.id, :master_type_id => quality_level.master_type_id, :check_list_status => false)		
				end
			end
		end		
	end

	def redirect_path
      	quality_lot_path(self)
  	end

	validate :check_lot_quantity

	def check_lot_quantity
		if self.persisted?
			lot_total_quantity = self.po_line.quality_lots.where("id != ?", self.id).sum(:lot_quantity)
			if (lot_total_quantity + self.lot_quantity) > self.po_line.po_line_quantity
				errors.add(:lot_quantity, "exceeded than PO item quantity (#{(lot_total_quantity - self.po_line.po_line_quantity).abs})")
			end
		else
			lot_total_quantity = self.po_line.quality_lots.sum(:lot_quantity)
			if (lot_total_quantity + self.lot_quantity) > self.po_line.po_line_quantity
				errors.add(:lot_quantity, "exceeded than item quantity (#{(lot_total_quantity - self.po_line.po_line_quantity).abs})")
			end
		end
		# errors.add(:lot_quantity, " #{lot_total_quantity},  #{self.lot_quantity},  #{self.po_line.po_line_quantity})")
	end

	def set_lot_control_no
		# current_count = self.po_line.quality_lots.where("month(created_at) = ?", Date.today.month).count
		maximum_lot = self.po_line.item.quality_lots.maximum(:lot_control_no)
		current_count = maximum_lot.nil? ? 0 : maximum_lot.split("-")[1].to_i

		"%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + 
		CommonActions.current_hour_letter + Time.now.min.to_s + "-" + (current_count + 1).to_s
	end

	def lot_with_part_no
		"#{self.lot_control_no} / #{self.po_line.po_line_item_name}"
	end

	def lot_item_material_elements
		(self.item_revision.present? && self.item_revision.material.present?) ?	self.item_revision.material.material_elements : []
	end

	def lot_item_dimensions
		self.item_revision.present? ? self.item_revision.item_part_dimensions.order(:item_part_letter) : []
	end

  	def process_quality_lot_dimensions(params)
  		self.quality_lot_dimensions.destroy_all
  		params[:dimension_field_data] ||= []
  		params[:dimension_field_data].each do |row_index, row_data|
  			row_data.each do |field_index, field_data|
  				QualityLotDimension.create(quality_lot_id: self.id, 
				item_part_dimension_id: params[:dimension_header_data][field_index], 
				lot_dimension_value: field_data)
  			end
  		end
  	end


  	def process_quality_lot_capabilities(params)
  		self.quality_lot_capabilities.destroy_all
  		params[:capability_field_data] ||= []
  		params[:capability_field_data].each do |row_index, row_data|
  			row_data.each do |field_index, field_data|
  				QualityLotCapability.create(quality_lot_id: self.id, 
				item_part_dimension_id: params[:capability_header_data][field_index], 
				lot_dimension_value: field_data)
  			end
  		end
  	end


  	def lot_material_elements
  		lot_material_elements = []
	    if self.present? 
	        if self.quality_lot_materials.any?
	            lot_material_elements = self.quality_lot_materials
	        elsif self.item_revision.present? && self.item_revision.material.present? && self.item_revision.material.material_elements.any?
	        	lot_material_elements = self.item_revision.material.material_elements.map {|element| element.quality_lot_materials.build }
	        end
	    end
		lot_material_elements    	
 	end

 	def get_quality_level
 		so_line = SoLine.find_by_so_line_vendor_po_and_item_id(self.po_header.po_identifier, self.po_line.item.id)
 		if so_line && so_line.customer_quality.present?
 			so_line.customer_quality
 		elsif po_line.organization.customer_quality.present?
 			po_line.organization.customer_quality
 		else
 			default = MasterType.find_by_type_category("default_customer_quality").type_value
 			CustomerQuality.find(default)
 		end
 	end
  	
end
