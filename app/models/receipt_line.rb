class ReceiptLine < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :receivable

  attr_accessible :receipt_line_amount, :receipt_line_created_id, :receipt_line_updated_id, 
  :receipt_id, :receivable_id

  validates_presence_of :receipt_line_amount, :receivable_id

  # validates :receivable_id, uniqueness: { scope: :receipt_id }

  validate :check_total_received

  def other_receipt_lines
      self.receivable.receipt_lines.where("id != ?", self.id)
  end

  def check_total_received
      total_shipped = self.other_receipt_lines.sum(:receipt_line_amount) + self.receipt_line_amount
      if total_shipped > self.receivable.receivable_total
        errors.add(:receipt_line_amount, "exceeded than receivable total!")
      end

      # receivable_ids = self.receipt.receipt_lines.collect(&:receivable_id)

      # if receivable_ids.uniq.length != receivable_ids.length 
      #     errors.add(:receipt_line_amount, "duplicate receivable entry!")
      # end
  end

  after_save :process_after_save

  def process_after_save
      Receivable.skip_callback("save", :before, :process_before_save)
      Receivable.skip_callback("save", :after, :process_after_save)

      receivable_balance = self.receivable.receivable_current_balance
      if receivable_balance > 0
          self.receivable.update_attributes(:receivable_status => "open")
      else
          self.receivable.update_attributes(:receivable_status => "closed")
      end

      Receivable.set_callback("save", :before, :process_before_save)
      Receivable.set_callback("save", :after, :process_after_save)
  end

end
