# == Schema Information
#
# Table name: so_shipments
#
#  id                     :integer          not null, primary key
#  so_line_id             :integer
#  so_shipped_count       :integer          default(0)
#  so_shipped_cost        :decimal(25, 10)  default(0.0)
#  so_shipped_shelf       :string(255)
#  so_shipped_unit        :string(255)
#  so_shipped_status      :string(255)
#  so_shipment_created_id :integer
#  so_shipment_updated_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#  quality_lot_id         :integer          default(0)
#  so_header_id           :integer
#  shipment_process_id    :string(255)
#

class SoShipment < ActiveRecord::Base
  belongs_to :so_line
  belongs_to :item

  validate :check_total_shipped

  has_one :receivable_so_shipment, :dependent => :destroy
  has_one :receivable, through: :receivable_so_shipment
  belongs_to :quality_lot



  after_save :set_so_line_status
  after_destroy :set_so_line_status

  before_save :process_before_save

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

  def process_before_save
    self.so_shipped_cost = self.so_shipped_count.to_f * self.so_line.so_line_sell
    self.so_header_id = self.so_line.so_header.id
    unless ["shipped", "on hold", "rejected"].include?(self.so_shipped_status)
      self.so_shipped_status = (self.so_line.so_header.po_header.present? && ['transer', 'direct'].include?(self.so_line.so_header.po_header.po_type.type_value)) ? "ship_in" : "process" unless self.so_shipped_status == 'ship_close' || self.so_shipped_status == 'ship_in'


      unless SoShipment.where('shipment_process_id IS NOT NULL').first.present?
        self.shipment_process_id = "S00001"
      else
          so_shipment_process = SoShipment.where(:so_header_id => self.so_header_id, :so_shipped_status => ['ship_in','process','ship_close'])
        if so_shipment_process.count >= 1
          so_shipment = so_shipment_process.last
          unless so_shipment.shipment_process_id.present?
            self.shipment_process_id = CommonActions.get_new_identifier(SoShipment, :shipment_process_id, "S")
          else
            self.shipment_process_id = so_shipment.shipment_process_id
          end
        else
          self.shipment_process_id = CommonActions.get_new_identifier(SoShipment, :shipment_process_id, "S")
        # last_shipment = SoShipment.last
        # if last_shipment.present? && last_shipment.shipment_process_id.present?
        #   shipment_process_id = SoShipment.maximum(:shipment_process_id).split('',2)[1].to_i
        #   self.shipment_process_id = 'S'+(1 + shipment_process_id).to_s
        # else
        #   self.shipment_process_id = 'S'+1.to_s
        # end
        end
      end
    end

  end


  def set_so_line_status
    if self.so_line
      SoLine.skip_callback("save", :before, :update_item_total, raise: false)
      # SoLine.skip_callback("save", :after, :update_so_total, raise: false)
      so_shipped = (self.so_shipped_status == "ship_close") ? self.so_line.so_line_quantity : self.so_total_shipped
      so_status = (so_shipped == self.so_line.so_line_quantity) ? "closed" : "open"
      self.so_line.update_attributes(:so_line_shipped => so_shipped, :so_line_status => so_status)
      so_status_count = self.so_line.so_header.so_lines.where("so_line_status = ?", "open").count
      so_header_status = (so_status_count == 0) ? "closed" : "open"
      self.so_line.so_header.update_attributes(:so_status => so_header_status)
      SoLine.set_callback("save", :before, :update_item_total)
      # SoLine.set_callback("save", :after, :update_so_total)
    end
  end

  def receivable_checkbox(mode)
    (mode == "history") ? "" : "<input type='checkbox' class='receivable_so_lines receivable_so_lines_#{self.so_line.so_header_id}' name='receivable_so_lines' value='#{self.id}'>  "
  end

  # scope :open_shipments, where("id not in (?)", [0] + ReceivableSoShipment.all.collect(&:so_shipment_id))
  # scope :closed_shipments, where(:id => ReceivableSoShipment.all.collect(&:so_shipment_id))

  def self.open_shipments(shipments=nil)
      shipments ||= SoShipment
      shipments.where("id not in (?)", [0] + ReceivableSoShipment.all.collect(&:so_shipment_id).compact).order('created_at desc')
  end

  def self.closed_shipments(shipments=nil)
      shipments ||= SoShipment
      shipments.where("so_shipments.id in (?)", ReceivableSoShipment.all.collect(&:so_shipment_id)).order('created_at desc')
  end
  def self.all_shipments(itemId)
    SoShipment.joins(:so_line).where(:so_lines => {:item_id => itemId})
  end

  def self.all_revision_shipments(itemRevisionId)
    SoShipment.joins(:quality_lot).where(:quality_lots => {:item_revision_id => itemRevisionId})
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
        quality_lot.lot_status = "closed"
        quality_lot.final_date = Time.now
      end
      if quality_lot.save(:validate => false)
        p quality_lot.to_yaml
      end
    end
  end

  def self.update_quality_on_hand(shipment)
    if shipment.quality_lot_id.present?
      quality_lot = QualityLot.find(shipment.quality_lot)
      if quality_lot.present?
          quantity_on_hand = quality_lot.quantity_on_hand += shipment.so_shipped_count
          quality_lot.update_attributes(lot_status: 'open', quantity_on_hand:  quantity_on_hand, finished: false)
        # quality_lot.save
      end
    end
  end

  def self.complete_shipment(shipment_process_id)
      SoShipment.where(:shipment_process_id => shipment_process_id, :so_shipped_status => ["ship_in"]).update_all(:so_shipped_status => "ship_out")
      so_shipments = SoShipment.where(:so_shipped_status => "ship_out").collect(&:id)
      so_shipments.each do |so_shipment_id|
        if so_shipment_id.present?
          ReceivableSoShipment.create(so_shipment_id: so_shipment_id)
        end
      end
      SoShipment.where(:shipment_process_id => shipment_process_id, :so_shipped_status => ["process", "ship_close"]).update_all(:so_shipped_status => "shipped")

  end
  def close_all_so_lines?(shipment_id)
    finished = 1
    soHeaderId = SoShipment.find(shipment_id).so_header_id
    SoLine.where(:so_header_id => soHeaderId).each do |so_line|
     if so_line.so_line_status != 'closed'
      finished = 0
     end
    end
    finished
  end


end
