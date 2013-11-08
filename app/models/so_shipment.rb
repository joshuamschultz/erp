class SoShipment < ActiveRecord::Base
  belongs_to :so_line

  attr_accessible :so_line_id, :so_shipment_updated_id, :so_shipment_created_id, 
  :so_shipped_cost, :so_shipped_count, :so_shipped_shelf, :so_shipped_unit, :so_shipped_status

  validate :check_total_shipped

  def check_total_shipped
		total_shipped = self.other_so_shipments.sum(:so_shipped_count) + self.so_shipped_count

		puts self.other_so_shipments.sum(:so_shipped_count)
		puts self.so_shipped_count

		if total_shipped > self.so_line.so_line_quantity
		 	errors.add(:so_shipped_count, "Exceeded than ordered!")
		end
  end

  def other_so_shipments
  		self.new_record? ? self.so_line.so_shipments : self.so_line.so_shipments.where("id != ?", self.id)
  end

  def so_total_shipped
  		self.so_line.present? ? self.so_line.so_shipments.sum(:so_shipped_count) : 0
  end

  after_save :set_so_line_status
  after_destroy :set_so_line_status

  def set_so_line_status
    if self.so_line
      SoLine.skip_callback("save", :before, :update_item_total)
      SoLine.skip_callback("save", :after, :update_so_total)
      so_shipped = self.so_total_shipped
      so_status = (so_shipped == self.so_line.so_line_quantity) ? "closed" : "open"
      self.so_line.update_attributes(:so_line_shipped => so_shipped, :so_line_status => so_status)
      SoLine.set_callback("save", :before, :update_item_total)
      SoLine.set_callback("save", :after, :update_so_total)
    end
  end

end
