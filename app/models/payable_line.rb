# == Schema Information
#
# Table name: payable_lines
#
#  id                       :integer          not null, primary key
#  payable_id               :integer
#  payable_line_identifier  :string(255)
#  payable_line_description :string(255)
#  payable_line_cost        :decimal(25, 10)  default(0.0)
#  payable_line_notes       :text(65535)
#  payable_line_status      :string(255)
#  payable_line_active      :boolean
#  payable_line_created_id  :integer
#  payable_line_updated_id  :integer
#  created_at               :datetime
#  updated_at               :datetime
#

class PayableLine < ActiveRecord::Base
    belongs_to :payable
    attr_accessible :payable_line_active, :payable_line_cost, :payable_line_created_id, 
    :payable_line_description, :payable_line_identifier, :payable_line_notes, :payable_line_status, 
    :payable_line_updated_id, :payable_id

    validates_presence_of :payable_line_description, :payable_line_cost

    validates_numericality_of :payable_line_cost

    after_save :update_payable_total
    after_destroy :update_payable_total

    def update_payable_total
    	  payable_total = self.payable.process_payable_total          
    end   

end
