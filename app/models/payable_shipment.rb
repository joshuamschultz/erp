# == Schema Information
#
# Table name: payable_shipments
#
#  id                          :integer          not null, primary key
#  payable_id                  :integer
#  po_line_id                  :integer
#  payable_shipment_identifier :string(255)
#  payable_shipment_count      :integer          default(0)
#  payable_shipment_cost       :decimal(25, 10)  default(0.0)
#  payable_shipment_created_id :integer
#  payable_shipment_updated_id :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#

class PayableShipment < ActiveRecord::Base
  belongs_to :payable
  belongs_to :po_line

  attr_accessible :payable_shipment_cost, :payable_shipment_count, :payable_shipment_created_id, 
  :payable_shipment_identifier, :payable_shipment_updated_id, :payable_id, :po_line_id

  before_save :process_before_save

  validates_presence_of :payable_shipment_count

  validates_numericality_of :payable_shipment_count

  def process_before_save
		  self.payable_shipment_cost = self.payable_shipment_count.to_f * self.po_line.po_line_cost
  end

  # after_destroy :process_after_destroy

  def process_after_destroy
  		self.payable.process_payable_total if self.payable
  end

  validate :check_total_received, :on => :update

  # def check_total_received
  # 		total_received = self.po_line.payable_shipments.where("id != ?", self.id).sum(:payable_shipment_count) + self.payable_shipment_count.to_f
  # 		if total_received > self.po_line.po_line_quantity
  # 			 errors.add(:payable_shipment_count, "exceeded than ordered!")
  # 		end
  # end

  def check_total_received
      total_received = self.other_payable_shipments.sum(:payable_shipment_count) + self.payable_shipment_count.to_f
      if total_received > self.po_line.po_line_shipped
          errors.add(:payable_shipment_count, "exceeded than total received!")
      end
  end

  def other_payable_shipments
      self.po_line.payable_shipments.where("id != ?", self.id)
  end

end
