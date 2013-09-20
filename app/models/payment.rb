class Payment < ActiveRecord::Base
  has_many :payment_lines, :dependent => :destroy
  belongs_to :organization

  attr_accessible :payment_active, :payment_check_amount, :payment_check_code, :payment_check_no, 
  :payment_created_id, :payment_description, :payment_identifier, :payment_notes, :payment_status, 
  :payment_type_id, :payment_updated_id, :organization_id, :payment_lines_attributes

  accepts_nested_attributes_for :payment_lines, :reject_if => lambda { |b| b[:payment_line_amount].blank? || b[:payable_id].blank? }

  belongs_to :payment_type, :class_name => "MasterType", :foreign_key => "payment_type_id", 
  	:conditions => ['type_category = ?', 'payment_type']

  def process_removed_lines(payment_lines)  		
    	payment_lines.each do |key, payment_line|
			if payment_line["payable_id"].nil?
				line = PaymentLine.find(payment_line["id"])
				line.destroy
				payment_lines.delete(key)
			end
    	end
    	payment_lines
  end

end
