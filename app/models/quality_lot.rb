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
	after_create :after_create_values
	# before_save :before_save_values
	def before_create_values
		self.lot_control_no = self.set_lot_control_no
	end

	
	# def  before_save_values
	# 	self.quantity_on_hand = self.lot_quantity
	# end

  	attr_accessible :po_header_id, :po_line_id, :item_revision_id, :inspection_level_id, :inspection_method_id, 
  	:inspection_type_id, :lot_active, :lot_control_no, :lot_created_id, :lot_finalized_at, :lot_inspector_id, 
  	:lot_notes, :lot_quantity, :lot_updated_id, :lot_aql_no, :fmea_type_id, :control_plan_id, :process_flow_id,
  	:lot_shelf_idenifier, :lot_shelf_unit, :lot_shelf_number, :quality_lot_materials_attributes, :run_at_rate_id,
  	:fai, :finished, :quantity_on_hand

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
	has_many :quality_lots
	has_one :package, :dependent => :destroy
	has_one :checklist, :dependent => :destroy
	has_one :ppap, :dependent => :destroy
  	has_many :inventory_adjustments, :dependent => :destroy
  	# has_one :po_shipment, :dependent => :destroy

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
			# self.checklist.destroy
			self.checklist.update_attributes(:po_line_id => self.po_line.id, :customer_quality_id => self.get_quality_level.id)
			if self.checklist
				self.checklist.check_list_lines.destroy_all if self.checklist.check_list_lines.present?
				self.get_quality_level.customer_quality_levels.each do |quality_level|
					CheckListLine.create(:checklist_id => self.checklist.id, :master_type_id => quality_level.master_type_id, :check_list_status => false)		
				end
			end
		end

	end



	def redirect_path
      	quality_lot_path(self)
  	end

	validate :check_lot_quantity

	def check_lot_quantity
		if self.lot_quantity.present?
			# self.lot_quantity ||= 0
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
		else
			errors.add(:lot_quantity, "Lot quantity should not empty")
		end
	end

	def set_lot_control_no
		# current_count = self.po_line.quality_lots.where("month(created_at) = ?", Date.today.month).count
	
		current_count = 0
		current_letter = '@'
		if self.po_line.item.quality_lots.present?
			# quality_lot_id = self.po_line.item.quality_lots.maximum(:id) 
			# maximum_lot = QualityLot.find(quality_lot_id).lot_control_no
			maximum_lot = self.po_line.item.quality_lots.maximum(:lot_control_no)
			current_count = maximum_lot.nil? ? 0 : maximum_lot.split("-")[1].to_i
			# p current_letter = maximum_lot.nil? ? '@' : maximum_lot.split("-")[0].split(//).last(1)[0]			
		 #    p maximum_lot[0, 8]
		end
		# o = [('A'..'Z')].map { |i| i.to_a }.flatten
		# random_letter = (0...1).map { o[rand(o.length)] }.join	

        
		min = (Time.now.min.to_i <10 ) ? "0"+Time.now.min.to_s : Time.now.min.to_s


		control_string = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + 
		CommonActions.current_hour_letter + min.to_s
		# unless  maximum_lot.nil?			
		letter = '@'
		# if MaxControlString.first && MaxControlString.first.control_string
		# 		# current_letter = MaxControlString.first.control_string.split(//).last(1)[0].to_s
		
		# 		begin
		# 			letter = letter.next!
		# 		end while (not MaxControlString.find_by_control_string("%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + 
		# CommonActions.current_hour_letter + min.to_s + "#{letter}".to_s).blank?)
        			

		# 		# current_letter =  (control_string == MaxControlString.first.control_string[0, 8]) ? current_letter : '@'	
		# else 		
		# 		letter = letter.next!
		# end				
		# end		
		begin
			letter = letter.next!
			count = current_count + 1
			@max_control_string = MaxControlString.where(:control_string => control_string+letter+'-'+count.to_s)
		end while(@max_control_string.present?)			
		MaxControlString.create(:control_string => control_string+letter+'-'+count.to_s)	
		

		
		  		 	

		# temp ="%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + CommonActions.current_hour_letter + min.to_s  + "#{letter}-" + (count).to_s
		# final = QualityLot.last.lot_control_no
		# if temp == final
		# 	count = count + 1
		# end
		temp = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + CommonActions.current_hour_letter + min.to_s  + "#{letter}-" + (count).to_s
		control_count = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + CommonActions.current_hour_letter + min.to_s  + "#{letter}-" 
		countrol_letter = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + CommonActions.current_hour_letter + min.to_s 

		check_lot = QualityLot.where(:lot_control_no => temp)
		p "===================="
		p checklist 
		p "=================="
		if check_lot.present?
			if check_lot == temp
				letter = letter.next!
				count = current_count + 1
				temp = "%02d" % Date.today.month + "%02d" % Date.today.day + (Date.today.year % 10).to_s + CommonActions.current_hour_letter + min.to_s  + "#{letter}-" + (count).to_s
			end
		end
		temp


	end


	def after_create_values
	 #    control_no = self.lot_control_no		
		# current_count = control_no.split("-")[1].to_i
		# letter = control_no.split("-")[0].split(//).last(1)[0].to_s	
		# control_string = control_no[0,8]

		# @quality_lot =QualityLot.where("lot_control_no = :lot_control_no AND id != :lot_id ", {lot_control_no: self.lot_control_no, lot_id: self.id }).first		
		# if @quality_lot.present?			
		# 	begin
		# 		letter = letter.next!
		# 		current_count = current_count +1
		# 		@max_control_string = MaxControlString.where(:control_string => control_string+letter)
		# 	end while(@max_control_string.present?)		
		# end		
		# MaxControlString.create(:control_string => control_string+letter)	 
		# self.update_attributes(:lot_control_no => control_string+"#{letter}-"+ (current_count).to_s)


		

	end
	def self.summa(lot)
		
		# control_no = lot.lot_control_no		
		# current_count = control_no.split("-")[1].to_i
		# letter = control_no.split("-")[0].split(//).last(1)[0].to_s	
		# control_string = control_no[0,8]

		# @quality_lot =QualityLot.where("lot_control_no = :lot_control_no AND id != :lot_id ", {lot_control_no: lot.lot_control_no, lot_id: lot.id }).first		
		# if @quality_lot.present?			
		# 	begin
		# 		letter = letter.next!
		# 		current_count = current_count +1
		# 		@max_control_string = MaxControlString.where(:control_string => control_string+letter)
		# 	end while(@max_control_string.present?)		
		# end		
		# MaxControlString.create(:control_string => control_string+letter)	
		# previous_lot = lot.id
		# previous_lot = previous_lot-1


		# pre_control_no = QualityLot.find(previous_lot).lot_control_no 
		# if lot.lot_control_no == pre_control_no
		# 	letter = letter.next!
		# 	current_count = current_count +1

		# elsif lot.lot_control_no.split("-")[1].to_i ==  pre_control_no.split("-")[1].to_i

		#  	current_count = current_count +1



		# end
		# lot.update_attributes(:lot_control_no => control_string+"#{letter}-"+ (current_count).to_s)
		# lot.po_line.item.quality_lots.each do |quality_lot|
		# 	if lot.lot_control_no == quality_lot.lot_control_no
		# 		letter = letter.next!
		# 		current_count = current_count +1

		# 	elsif lot.lot_control_no.split("-")[1].to_i ==  quality_lot.lot_control_no.split("-")[1].to_i
		# 		current_count = current_count +1
		# 	end
		# 	lot.update_attributes(:lot_control_no => control_string+"#{letter}-"+ (current_count).to_s)
		# end
		# last = QualityLot.last
		# last.po_line.item.quality_lots.each do |quality_lot|
		# 	if last.lot_control_no == quality_lot.lot_control_no
		# 		letter = letter.next!
		# 		current_count = current_count +1

		# 	elsif last.lot_control_no.split("-")[1].to_i ==  quality_lot.lot_control_no.split("-")[1].to_i
		# 		current_count = current_count +1
		# 	end
		# 	last.update_attributes(:lot_control_no => control_string+"#{letter}-"+ (current_count).to_s)
		# end

	


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
 		elsif po_line.organization.present?
 			po_line.customer_quality 
 		elsif CustomerQuality.first
 			CustomerQuality.first
 		else
 			default = MasterType.find_by_type_category("default_customer_quality").type_value
 			CustomerQuality.find(default)
 		end
 	end

 	def get_guage_dimensions
 		temp = []
 		self.lot_item_dimensions.each do |lot_dimension|
 			k = []
 			unless lot_dimension.go_non_go
 			 	k << lot_dimension.item_part_letter
 			 	k <<  lot_dimension.id
 			 	temp << k
 			end 			
 		end
 		p '-------------------------'
 		p temp
 		temp
 	end
  	
end
