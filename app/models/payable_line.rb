class PayableLine < ActiveRecord::Base
  belongs_to :payable
  attr_accessible :payable_line_active, :payable_line_cost, :payable_line_created_id, 
  :payable_line_description, :payable_line_identifier, :payable_line_notes, :payable_line_status, 
  :payable_line_updated_id, :payable_id

  validates_presence_of :payable_line_description, :payable_line_cost

  after_save :update_payable_total
  after_destroy :update_payable_total

  def update_payable_total
  	  payable_total = self.payable.process_payable_total
  end

end
