# == Schema Information
#
# Table name: receivable_shipments
#
#  id                             :integer          not null, primary key
#  receivable_id                  :integer
#  so_line_id                     :integer
#  receivable_shipment_identifier :string(255)
#  receivable_shipment_count      :integer          default(0)
#  receivable_shipment_cost       :decimal(25, 10)  default(0.0)
#  receivable_shipment_created_id :integer
#  receivable_shipment_updated_id :integer
#  created_at                     :datetime
#  updated_at                     :datetime
#

class ReceivableShipment < ActiveRecord::Base
  belongs_to :receivable
  belongs_to :so_line


  validates_presence_of :receivable_shipment_count

  validates_numericality_of :receivable_shipment_count

  before_save :process_before_save

  def process_before_save
		self.receivable_shipment_cost = self.receivable_shipment_count.to_f * self.so_line.so_line_cost
  end

  after_destroy :process_after_destroy

  def process_after_destroy
  		self.receivable.process_receivable_total if self.receivable
  end

  validate :check_total_shipped, :on => :update

  # def check_total_shipped
  # 		total_shipped = self.so_line.receivable_shipments.where("id != ?", self.id).sum(:receivable_shipment_count) + self.receivable_shipment_count.to_f
  # 		if total_shipped > self.so_line.so_line_quantity
  # 			errors.add(:receivable_shipment_count, "exceeded than ordered!")
  # 		end
  # end

  def check_total_shipped
      total_shipped = self.other_receivable_shipments.sum(:receivable_shipment_count) + self.receivable_shipment_count.to_f
      if total_shipped > self.so_line.so_line_shipped
          errors.add(:receivable_shipment_count, "exceeded than total shipped!")
      end
  end

  def other_receivable_shipments
      self.so_line.receivable_shipments.where("id != ?", self.id)
  end

end
