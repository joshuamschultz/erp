class Receipt < ActiveRecord::Base
  include Rails.application.routes.url_helpers 

  has_many :receipt_lines, :dependent => :destroy, :before_add => :set_receipt
  belongs_to :organization

  attr_accessible :receipt_active, :receipt_check_amount, :receipt_check_code, :receipt_check_no, 
  :receipt_created_id, :receipt_description, :receipt_identifier, :receipt_notes, :receipt_status, 
  :receipt_type_id, :receipt_updated_id, :organization_id, :receipt_lines_attributes

  scope :status_based_receipts, lambda{|status| where(:receipt_status => status) }

  accepts_nested_attributes_for :receipt_lines, :reject_if => lambda { |b| b[:receipt_line_amount].blank? || b[:receivable_id].blank? }

  belongs_to :receipt_type, :class_name => "MasterType", :foreign_key => "receipt_type_id", :conditions => ['type_category = ?', 'payment_type']

  # belongs_to :check_entry, :class_name => "CheckEntry", :foreign_key => "receipt_check_code", :primary_key => 'check_code'

  validates_presence_of :organization

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
      receivable_ids = self.receipt_lines.collect(&:receivable_id)
      if receivable_ids.uniq != receivable_ids 
          errors.add(:organization_id, "have duplicate receivable entries added!")
      end

      total_amount = 0
      self.receipt_lines.each{|b| total_amount += b.receipt_line_amount.to_f }
      self.receipt_check_amount = total_amount

      if self.receipt_lines.empty?
        errors.add(:receipt_check_amount, "is not assigned to any SO!")

      # elsif total_amount > self.receipt_check_amount
      #   errors.add(:receipt_check_amount, "is not sufficient!  Total line amount needed: #{total_amount}")
      end
  end

  before_create :process_before_create

  def process_before_create
      self.receipt_identifier = CommonActions.get_new_identifier(Receipt, :receipt_identifier)
  end

  def redirect_path
      receipt_path(self)
  end

  private

  def set_receipt(line)
      line.receipt ||= self
  end

end
