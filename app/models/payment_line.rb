class PaymentLine < ActiveRecord::Base
  belongs_to :payment
  belongs_to :payable
  attr_accessible :payment_line_amount, :payment_line_created_id, :payment_line_updated_id, 
  :payment_id, :payable_id

  validates_presence_of :payment_line_amount, :payable_id

  validate :check_total_received

  # validates :payable_id, uniqueness: { scope: :payment_id }

  def other_payment_lines
      self.payable.payment_lines.where("id != ?", self.id)
  end

  def check_total_received
  		total_received = self.other_payment_lines.sum(:payment_line_amount) + self.payment_line_amount
  		if total_received > self.payable.payable_total
  			 errors.add(:payment_line_amount, "exceeded than payable total!")
  		end

      # payable_ids = self.payment.payment_lines.collect(&:payable_id)

      # if self.new_record? && payable_ids.uniq.length != payable_ids.length
      #     errors.add(:payment_line_amount, "duplicate payable entry!")
      # end
  end

  # validates :payment_id, :uniqueness => { :scope => :payable_id, :message => "duplicate entry!" }

  after_save :process_after_save

  def process_after_save
      Payable.skip_callback("save", :before, :process_before_save)
      Payable.skip_callback("save", :after, :process_after_save)

      payable_balance = self.payable.payable_current_balance
      if payable_balance > 0
          self.payable.update_attributes(:payable_status => "open")
      else
          self.payable.update_attributes(:payable_status => "closed")
      end

      Payable.set_callback("save", :before, :process_before_save)
      Payable.set_callback("save", :after, :process_after_save)
  end

end
