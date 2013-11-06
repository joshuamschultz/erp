class PoShipment < ActiveRecord::Base
  belongs_to :po_line

  has_one :payable_po_shipment
  has_one :payable, through: :payable_po_shipment
  
  attr_accessible :po_line_id, :po_shipment_created_id, :po_shipment_updated_id, 
  :po_shipped_count, :po_shipped_cost, :po_shipped_shelf, :po_shipped_unit

  scope :open_shipments, where("id not in (?)", [0] + PayablePoShipment.all.collect(&:po_shipment_id))

  scope :closed_shipments, where(:id => PayablePoShipment.all.collect(&:po_shipment_id))

  before_save :process_before_save

  def process_before_save
      self.po_shipped_cost = self.po_shipped_count.to_f * self.po_line.po_line_cost
  end

  def payable_checkbox(mode)
    (mode == "history") ? "" : "<input type='checkbox' class='payable_po_lines payable_po_lines_#{self.po_line.po_header_id}' name='payable_po_lines' value='#{self.id}'>  "
  end

  validate :check_total_shipped

  def check_total_shipped
		total_shipped = self.other_po_shipments.sum(:po_shipped_count) + self.po_shipped_count

		puts self.other_po_shipments.sum(:po_shipped_count)
		puts self.po_shipped_count

		if total_shipped > self.po_line.po_line_quantity
		 	errors.add(:po_shipped_count, "Exceeded than ordered!")
		end
  end

  def other_po_shipments
		self.new_record? ? self.po_line.po_shipments : self.po_line.po_shipments.where("id != ?", self.id)
  end

  def po_total_shipped
  		self.po_line.po_shipments.sum(:po_shipped_count)
  end

  after_save :set_po_line_status
  after_destroy :set_po_line_status

  def set_po_line_status
    if self.po_line
      PoLine.skip_callback("save", :before, :update_item_total)
      PoLine.skip_callback("save", :after, :update_po_total)
      po_shipped = self.po_total_shipped
      po_status = (po_shipped == self.po_line.po_line_quantity) ? "closed" : "open"
      self.po_line.update_attributes(:po_line_shipped => po_shipped, :po_line_status => po_status)
      PoLine.set_callback("save", :before, :update_item_total)
      PoLine.set_callback("save", :after, :update_po_total)
    end
  end
end
