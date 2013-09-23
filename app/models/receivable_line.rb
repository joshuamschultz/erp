class ReceivableLine < ActiveRecord::Base
	belongs_to :receivable
	attr_accessible :receivable_line_active, :receivable_line_cost, :receivable_line_created_id, 
	:receivable_line_description, :receivable_line_identifier, :receivable_line_notes, :receivable_line_status, 
	:receivable_line_updated_id, :receivable_id

	validates_presence_of :receivable_line_description, :receivable_line_cost

	after_save :update_receivable_total
	after_destroy :update_receivable_total

	def update_receivable_total
		Receivable.skip_callback("save", :before, :process_before_save)
		receivable_total = self.receivable.update_receivable_total	  
		puts self.receivable.update_attributes(:receivable_total => receivable_total)
		Receivable.set_callback("save", :before, :process_before_save)
	end

end
