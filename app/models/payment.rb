class Payment < ActiveRecord::Base
  has_many :payment_lines, :dependent => :destroy
  belongs_to :organization

  attr_accessible :payment_active, :payment_check_amount, :payment_check_code, :payment_check_no, 
  :payment_created_id, :payment_description, :payment_identifier, :payment_notes, :payment_status, 
  :payment_type_id, :payment_updated_id, :organization_id, :payment_lines_attributes

  accepts_nested_attributes_for :payment_lines, :reject_if => lambda { |b| b[:payment_line_amount].blank? || b[:payable_id].blank? }

  belongs_to :payment_type, :class_name => "MasterType", :foreign_key => "payment_type_id", 
  	:conditions => ['type_category = ?', 'payment_type']

  validates_presence_of :organization, :payment_check_amount

  def process_removed_lines(payment_lines)
      if payment_lines && payment_lines.any?
        	payment_lines.each do |key, payment_line|
        			if payment_line["payable_id"].nil?
        				line = PaymentLine.find(payment_line["id"])
        				line.destroy
        				payment_lines.delete(key)
        			end
        	end
      else
          payment_lines = []
      end
    	payment_lines
  end

  validate :payment_total_amount

  def payment_total_amount
      total_amount = 0
      self.payment_lines.each{|b| total_amount += b.payment_line_amount.to_f }

      if self.payment_lines.empty?
        errors.add(:payment_check_amount, "is not assigned to any PO!")

      elsif total_amount > self.payment_check_amount
        errors.add(:payment_check_amount, "is not sufficient!  Total lines amount : #{total_amount}")
      end
  end

end
