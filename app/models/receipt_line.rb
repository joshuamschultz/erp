class ReceiptLine < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :receivable

  attr_accessible :receipt_line_amount, :receipt_line_created_id, :receipt_line_updated_id, 
  :receipt_id, :receivable_id

  validates_presence_of :receipt_line_amount, :receivable_id

  validate :check_total_received

  def check_total_received
      total_received = self.receivable.receipt_lines.sum(:receipt_line_amount) + self.receipt_line_amount
      puts total_received
      if total_received > self.receivable.receivable_total
        errors.add(:receipt_line_amount, "exceeded than receivable total!")
      end
      # errors.add(:receipt_line_amount, "exceeded than receivable total!")
  end
end
