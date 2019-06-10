# == Schema Information
#
# Table name: po_shipments
#
#  id                     :integer          not null, primary key
#  po_line_id             :integer
#  po_shipped_count       :integer          default(0)
#  po_shipped_cost        :decimal(25, 10)  default(0.0)
#  po_shipped_shelf       :string(255)
#  po_shipped_unit        :string(255)
#  po_shipped_status      :string(255)
#  po_shipment_created_id :integer
#  po_shipment_updated_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#  quality_lot_id         :integer
#

class PoShipment < ActiveRecord::Base
  belongs_to :po_line

  has_one :payable_po_shipment, :dependent => :destroy
  has_one :payable, through: :payable_po_shipment
  belongs_to :quality_lot, :dependent => :destroy

  after_save :update_status
  after_save :set_po_line_status
  after_destroy :set_po_line_status


  validate :check_total_shipped


  # validates_presence_of :po_shipped_shelf, message: "Shelf can't be blank!"
  # validates_presence_of :po_shipped_unit, message: "Unit can't be blank!"
  # validates_presence_of :po_shipped_count, message: "Receiving can't be blank!"

  def update_status
	  cost = self.po_shipped_count.to_f * self.po_line.po_line_cost
    unless ["received", "on hold", "rejected"].include?(self.po_shipped_status)
      status = 'received'
    else
    	status = self.po_shipped_status
    end
    self.update_columns(po_shipped_status: status, po_shipped_cost: cost)
  end

  def payable_checkbox(mode)
    (mode == "history") ? "" : "<input type='checkbox' class='payable_po_lines payable_po_lines_#{self.po_line.po_header_id}' name='payable_po_lines' value='#{self.id}'>  "
  end


  def check_total_shipped
    total_shipped = self.other_po_shipments.map(&:po_shipped_count).sum + self.po_shipped_count.to_i

    # puts self.other_po_shipments.sum(:po_shipped_count)
    # puts self.po_shipped_count

    if total_shipped > self.po_line.po_line_quantity
      errors.add(:po_shipped_count, "Exceeded than ordered!")
    else
    	puts 'validation success..'
    	true
    end
  end

  def other_po_shipments
    self.new_record? ? self.po_line.po_shipments : self.po_line.po_shipments.where("id != ?", self.id)
  end

  def po_total_shipped
      self.po_line.po_shipments.sum(:po_shipped_count)
  end

  def set_po_line_status
    if self.po_line
      po_shipped = self.po_total_shipped
      po_status = (po_shipped == self.po_line.po_line_quantity) ? 'closed' : 'open'
      self.po_line.update_columns(po_line_shipped: po_shipped, po_line_status: po_status)
      po_status_count = self.po_line.po_header.po_lines.where('po_line_status = ?', 'open').count
      po_header_status = (po_status_count == 0) ? 'closed' : 'open'
      self.po_line.po_header.update_column(:po_status, po_header_status)
    end


  end
  # after_commit :after_commit_process
  # def after_commit_process
  #   if self.quality_lot
  #     QualityLot.summa(self.quality_lot)
  #   end
  # end

  def self.open_shipments(po_shipments=nil)
      po_shipments ||= PoShipment#.joins(:po_line).order("po_lines.po_header_id, po_shipments.created_at") if po_shipments.nil?
      po_shipments.where("po_shipments.id not in (?)", [0] + PayablePoShipment.all.collect(&:po_shipment_id).compact).order('po_shipments.created_at desc')
  end

  def self.closed_shipments(po_shipments=nil)
      po_shipments ||= PoShipment#.joins(:po_line).order("po_lines.po_header_id, po_shipments.created_at") if po_shipments.nil?
      po_shipments.where("po_shipments.id in (?)", [0] + PayablePoShipment.all.collect(&:po_shipment_id).compact).order('po_shipments.created_at desc')
  end

  def self.all_shipments(itemId)
    PoShipment.joins(:po_line).where(:po_lines => {:item_id => itemId})
  end

  def self.all_revision_shipments(itemRevisionId)
    PoShipment.joins(:quality_lot).where(:quality_lots => {:item_revision_id => itemRevisionId})
  end

  def set_quality_on_hand
    if self.quality_lot.present?
      quality_lotss = self.quality_lot
      p '---------------------'
      p quality_lotss.quantity_on_hand
      p self.po_shipped_count
      # quality_lotss.lot_quantity = quality_lotss.lot_quantity + self.po_shipped_count
      quality_lotss.quantity_on_hand = quality_lotss.quantity_on_hand - self.po_shipped_count
      if quality_lotss.quantity_on_hand <= 0
        quality_lotss.finished = self.created_at
      end
      if quality_lotss.save(:validate => false)
        p quality_lotss.to_yaml
      end
    end
  end

  def close_all_po_lines?(shipment_id)
    finished = 1
    poHeaderId = PoShipment.find(shipment_id).po_line.po_header_id
    PoLine.where(:po_header_id => poHeaderId).each do |po_line|
     if po_line.po_line_status != 'closed'
      finished = 0
     end
    end
    finished
  end

  def po_line
    if self.new_record?
      PoLine.where(id: self.po_line_id).first
    else
      super
    end
  end
end
