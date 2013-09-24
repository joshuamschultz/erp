class ReceivableShipment < ActiveRecord::Base
  belongs_to :receivable
  belongs_to :so_line

  attr_accessible :receivable_shipment_cost, :receivable_shipment_count, 
  :receivable_shipment_created_id, :receivable_shipment_identifier, 
  :receivable_shipment_updated_id, :receivable_id, :so_line_id

  before_save :process_before_save

  def process_before_save
		self.receivable_shipment_cost = self.receivable_shipment_count * self.so_line.so_line_cost
  end

  after_destroy :process_after_destroy

  def process_after_destroy
  		self.receivable.process_receivable_total
  end

  validate :check_total_shipped, :on => :update

  def check_total_shipped
  		total_shipped = self.so_line.receivable_shipments.where("id != ?", self.id).sum(:receivable_shipment_count) + self.receivable_shipment_count
  		if total_shipped > self.so_line.so_line_quantity
  			errors.add(:receivable_shipment_count, "exceeded than ordered!")
  		end
  end

end
