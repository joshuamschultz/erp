class PaymentLine < ActiveRecord::Base
  belongs_to :payment
  belongs_to :payable
  attr_accessible :payment_line_amount, :payment_line_created_id, :payment_line_updated_id, 
  :payment_id, :payable_id

  validates_presence_of :payment_line_amount, :payable_id

  validate :check_total_received

  def other_payment_lines
      self.payable.payment_lines.where("id != ?", self.id)
  end

  def check_total_received
  		total_received = self.other_payment_lines.sum(:payment_line_amount) + self.payment_line_amount
  		if total_received > self.payable.payable_total
  			errors.add(:payment_line_amount, "exceeded than payable total!")
  		end

      if self.payable.payment_lines.collect(&:payable_id).include?(self.payable_id)
          errors.add(:payment_line_amount, "duplicate payable entry!")
      end
  end

  # validates :payment_id, :uniqueness => { :scope => :payable_id, :message => "duplicate entry!" }

end
