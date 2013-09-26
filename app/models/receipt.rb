class Receipt < ActiveRecord::Base
  has_many :receipt_lines, :dependent => :destroy
  belongs_to :organization

  attr_accessible :receipt_active, :receipt_check_amount, :receipt_check_code, :receipt_check_no, 
  :receipt_created_id, :receipt_description, :receipt_identifier, :receipt_notes, :receipt_status, 
  :receipt_type_id, :receipt_updated_id, :organization_id, :receipt_lines_attributes

  accepts_nested_attributes_for :receipt_lines, :reject_if => lambda { |b| b[:receipt_line_amount].blank? || b[:receivable_id].blank? }

  belongs_to :receipt_type, :class_name => "MasterType", :foreign_key => "receipt_type_id", 
  	:conditions => ['type_category = ?', 'payment_type']

  validates_presence_of :organization, :receipt_check_amount

  def process_removed_lines(receipt_lines)
      if receipt_lines && receipt_lines.any?
        	receipt_lines.each do |key, receipt_line|
        			if receipt_line["receivable_id"].nil?
        				line = ReceiptLine.find(receipt_line["id"])
        				line.destroy
        				receipt_lines.delete(key)
        			end
        	end
      else
          receipt_lines = []
      end
    	receipt_lines
  end

  validate :receipt_total_amount
  
  def receipt_total_amount
      total_amount = 0
      self.receipt_lines.each{|b| total_amount += b.receipt_line_amount.to_f }

      if self.receipt_lines.empty?
        errors.add(:receipt_check_amount, "is not assigned to any SO!")

      elsif total_amount > self.receipt_check_amount
        errors.add(:receipt_check_amount, "is not sufficient!  Total line amount : #{total_amount}")
      end
  end

end
