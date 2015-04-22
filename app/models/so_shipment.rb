class SoShipment < ActiveRecord::Base
  belongs_to :so_line

  attr_accessible :so_line_id, :so_shipment_updated_id, :so_shipment_created_id, :quality_lot_id,
  :so_shipped_cost, :so_shipped_count, :so_shipped_shelf, :so_shipped_unit, :so_shipped_status, :shipment_process_id, :so_header_id, :item_id

  validate :check_total_shipped

  has_one :receivable_so_shipment, :dependent => :destroy
  has_one :receivable, through: :receivable_so_shipment
  belongs_to :quality_lot

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

  before_save :process_before_save

  def process_before_save
      self.so_shipped_cost = self.so_shipped_count.to_f * self.so_line.so_line_sell
      self.so_header_id = self.so_line.so_header.id
      unless ["ship_close","shipped", "on hold", "rejected"].include?(self.so_shipped_status)
          self.so_shipped_status = "process"
           so_shipment = SoShipment.where(:so_header_id => self.so_header_id).count
           if so_shipment >= 1
              so_shipment = SoShipment.where(:so_header_id => self.so_header_id).first
              self.shipment_process_id = 'S'+so_shipment.shipment_process_id.split('',2)[1]
            else
              if SoShipment.last.shipment_process_id.present?
                shipment_process_id = SoShipment.maximum(:shipment_process_id).split('',2)[1].to_i
                self.shipment_process_id = 'S'+(1 + shipment_process_id).to_s
              else
                self.shipment_process_id = 'S'+1.to_s
              end
            end
      end
  end

  after_save :set_so_line_status
  after_destroy :set_so_line_status

  def set_so_line_status
    if self.so_line
      SoLine.skip_callback("save", :before, :update_item_total)
      SoLine.skip_callback("save", :after, :update_so_total)
      so_shipped = (self.so_shipped_status == "ship_close") ? self.so_line.so_line_quantity : self.so_total_shipped
      so_status = (so_shipped == self.so_line.so_line_quantity) ? "closed" : "open"
      self.so_line.update_attributes(:so_line_shipped => so_shipped, :so_line_status => so_status)
      so_status_count = self.so_line.so_header.so_lines.where("so_line_status = ?", "open").count
      so_header_status = (so_status_count == 0) ? "closed" : "open"
      self.so_line.so_header.update_attributes(:so_status => so_header_status) 
      SoLine.set_callback("save", :before, :update_item_total)
      SoLine.set_callback("save", :after, :update_so_total)
    end
  end

  def receivable_checkbox(mode)
    (mode == "history") ? "" : "<input type='checkbox' class='receivable_so_lines receivable_so_lines_#{self.so_line.so_header_id}' name='receivable_so_lines' value='#{self.id}'>  "
  end

  # scope :open_shipments, where("id not in (?)", [0] + ReceivableSoShipment.all.collect(&:so_shipment_id))
  # scope :closed_shipments, where(:id => ReceivableSoShipment.all.collect(&:so_shipment_id))

  def self.open_shipments(shipments)
      shipments ||= SoShipment
      shipments.where("so_shipments.id not in (?)", [0] + ReceivableSoShipment.all.collect(&:so_shipment_id)).order('created_at desc')
  end

  def self.closed_shipments(shipments)
      shipments ||= SoShipment
      shipments.where("so_shipments.id in (?)", ReceivableSoShipment.all.collect(&:so_shipment_id)).order('created_at desc')
  end
  def self.all_shipments(itemId)
    SoShipment.joins(:so_line).where(:so_lines => {:item_id => itemId})
  end 
  # def set_quality_on_hand
  #   if self.quality_lot.present?
  #     quality_lotss = self.quality_lot
  #     p '---------------------'
  #     p quality_lotss.quantity_on_hand
  #     p self.so_shipped_count
  #     # quality_lotss.lot_quantity = quality_lotss.lot_quantity + self.so_shipped_count
  #     quality_lotss.quantity_on_hand = quality_lotss.quantity_on_hand - self.so_shipped_count
  #     if quality_lotss.quantity_on_hand <= 0
  #       quality_lotss.finished = true
  #       quality_lotss.lot_finalized_at = Date.today.to_s
  #     end
  #     if quality_lotss.save(:validate => false)
  #       p quality_lotss.to_yaml
  #     end
  #   end    
  # end

    def set_quality_on_hand
    if self.quality_lot.present?
      quality_lot = self.quality_lot
      # quality_lotss.lot_quantity = quality_lotss.lot_quantity + self.so_shipped_count
      quality_lot.quantity_on_hand = quality_lot.quantity_on_hand - self.so_shipped_count
      if quality_lot.quantity_on_hand <= 0
        quality_lot.finished = true
        quality_lot.lot_finalized_at = Date.today.to_s
      end
      if quality_lot.save(:validate => false)
        p quality_lot.to_yaml
      end
    end    
  end

  def self.complete_shipment(so_id) 
    SoShipment.where("so_header_id=? AND so_shipped_status=?",so_id,"process").update_all(:so_shipped_status => "shipped")
  end

  
end
