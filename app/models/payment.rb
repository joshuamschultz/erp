class Payment < ActiveRecord::Base
  include Rails.application.routes.url_helpers 

  has_many :payment_lines, :dependent => :destroy, :before_add => :set_payment  

  belongs_to :organization

  attr_accessible :payment_active, :payment_check_amount, :payment_check_code, :payment_check_no, 
  :payment_created_id, :payment_description, :payment_identifier, :payment_notes, :payment_status, 
  :payment_type_id, :payment_updated_id, :organization_id, :payment_lines_attributes

  accepts_nested_attributes_for :payment_lines, :reject_if => lambda { |b| b[:payment_line_amount].blank? || b[:payable_id].blank? }

  belongs_to :payment_type, :class_name => "MasterType", :foreign_key => "payment_type_id", 
  	:conditions => ['type_category = ?', 'payment_type']

  belongs_to :check_entry, :class_name => "CheckEntry", :foreign_key => "payment_check_code", :primary_key => 'check_code'

  validates_presence_of :organization, :payment_check_amount

  # validate :validate_payment_check_code

  # def validate_payment_check_code
  #     if self.payment_type.present? && self.payment_type.type_value == "check"
  #         validates_presence_of :payment_check_code
  #         validates_uniqueness_of :payment_check_code
  #     end
  # end

  validates_presence_of :payment_check_code, :if => Proc.new { |o| (o.payment_type.present? && o.payment_type.type_value == "check") }
  validates_uniqueness_of :payment_check_code, :if => Proc.new { |o| (o.payment_type.present? && o.payment_type.type_value == "check") }

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
      payable_ids = self.payment_lines.collect(&:payable_id)
      if payable_ids.uniq != payable_ids 
          errors.add(:organization_id, "have duplicate payable entries added!")
      end

      total_amount = 0
      self.payment_lines.each{|b| total_amount += b.payment_line_amount.to_f }

      if self.payment_lines.empty?
        errors.add(:payment_check_amount, "is not assigned to any PO!")

      elsif total_amount > self.payment_check_amount
        errors.add(:payment_check_amount, "is not sufficient!  Total lines amount needed: #{total_amount}")
      end
  end

  before_create :process_before_create

  def process_before_create
      self.payment_identifier = CommonActions.get_new_identifier(Payment, :payment_identifier)
  end

  after_save :process_after_save

  def process_after_save
      if self.check_entry.nil? && self.payment_type.present? && self.payment_type.type_value == "check"
          CheckEntry.create(check_active: true, check_code: self.payment_check_code, check_identifier: "Check")
      end
  end

  def redirect_path
      payment_path(self)
  end

  private

  def set_payment(line)
      line.payment ||= self
      puts line.id
  end

end
