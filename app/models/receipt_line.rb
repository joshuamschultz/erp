class ReceiptLine < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :receivable

  attr_accessible :receipt_line_amount, :receipt_line_created_id, :receipt_line_updated_id, 
  :receipt_id, :receivable_id

  validates_presence_of :receipt_line_amount, :receivable_id

  validate :check_total_received

  def other_receipt_lines
      self.receivable.receipt_lines.where("id != ?", self.id)
  end

  def check_total_received
      total_shipped = self.other_receipt_lines.sum(:receipt_line_amount) + self.receipt_line_amount
      if total_shipped > self.receivable.receivable_total
        errors.add(:receipt_line_amount, "exceeded than receivable total!")
      end

      if self.new_record? && self.receivable.receipt_lines.collect(&:receivable_id).include?(self.receivable_id)
          errors.add(:receipt_line_amount, "duplicate receivable entry!")
      end
  end
end
