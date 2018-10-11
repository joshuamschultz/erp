# == Schema Information
#
# Table name: payment_lines
#
#  id                      :integer          not null, primary key
#  payment_id              :integer
#  payable_id              :integer
#  payment_line_amount     :decimal(25, 10)  default(0.0)
#  payment_line_created_id :integer
#  payment_line_updated_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class PaymentLine < ActiveRecord::Base
  belongs_to :payment
  belongs_to :payable
  attr_accessor :payment_line_amount, :payment_line_created_id, :payment_line_updated_id, 
  :payment_id, :payable_id

  validates_presence_of :payment_line_amount, :payable_id

  validates_numericality_of :payment_line_amount

  validate :check_total_received
 
  # validates :payable_id, uniqueness: { scope: :payment_id }
  # validates :payment_id, :uniqueness => { :scope => :payable_id, :message => "duplicate entry!" }

  def other_payment_lines
      self.payable.payment_lines.where("id != ?", self.id)
  end

  def check_total_received
  		total_received = self.other_payment_lines.sum(:payment_line_amount) + self.payment_line_amount

  		if total_received > self.payable.payable_total
  			 errors.add(:payment_line_amount, "exceeded than payable total!")
  		end

      # if self.payment.new_record? 
      #     payable_ids = self.payment.payment_lines.collect(&:payable_id)
      #     errors.add(:payment_line_amount, "duplicate payable entry!") unless payable_ids.uniq == payable_ids
      # end
  end

  after_save :process_after_save
  after_destroy :process_after_save

  def process_after_save
      self.payable.update_payable_status
  end

end
