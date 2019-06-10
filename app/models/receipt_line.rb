# == Schema Information
#
# Table name: receipt_lines
#
#  id                      :integer          not null, primary key
#  receipt_id              :integer
#  receivable_id           :integer
#  receipt_line_amount     :decimal(25, 10)  default(0.0)
#  receipt_line_created_id :integer
#  receipt_line_updated_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#

class ReceiptLine < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :receivable

  validates_presence_of :receipt_line_amount, :receivable_id

  validates_numericality_of :receipt_line_amount

  # validates :receivable_id, uniqueness: { scope: :receipt_id }

  validate :check_total_received

  after_save :process_after_save
  after_destroy :process_after_save

  before_create :process_before_create

  def other_receipt_lines
      self.receivable.receipt_lines.where("id != ?", self.id)
  end

  def check_total_received
      total_shipped = self.other_receipt_lines.sum(:receipt_line_amount) + self.receipt_line_amount
      if total_shipped > self.receivable.receivable_total
          errors.add(:receipt_line_amount, "exceeded than receivable total - discount!")
      end
      if self.receipt_line_amount > self.receivable.receivable_total
         errors.add(:receipt_line_amount, "exceeded than receivable total - discount!")
      end
      unless self.receipt.new_record?
          receivable_ids = self.receipt.receipt_lines.collect(&:receivable_id)
          errors.add(:receipt_line_amount, "duplicate receivable entry!") unless receivable_ids.uniq == receivable_ids
      end
  end



  def process_before_create
    self.receipt_line_amount = (self.receivable.receivable_total - ((self.receipt_line_amount*self.receipt.receipt_discount)/100).round(2))
  end

  def process_after_save
      Receivable.skip_callback("save", :before, :process_before_save, raise: false)
      Receivable.skip_callback("save", :after, :process_after_save, raise: false)

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
