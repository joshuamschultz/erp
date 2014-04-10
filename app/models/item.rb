class Item < ActiveRecord::Base
  attr_accessible :item_part_no, :item_quantity_in_hand, :item_quantity_on_order, :item_active,
  :item_created_id, :item_updated_id, :item_revisions_attributes

  has_many :item_revisions, :dependent => :destroy
  has_many :quote_lines, :dependent => :destroy
  has_many :quotes , :through => :quote_lines
  has_many :customer_quote_lines, :dependent => :destroy
  has_many :customer_quotes, :through => :customer_quote_lines

  has_many :item_part_dimensions, :through => :item_revisions

  has_many :po_lines, :dependent => :destroy
  has_many :po_shipments, :through => :po_lines
  has_many :quality_lots, :through => :po_lines

  has_many :so_lines, :dependent => :destroy
  has_many :so_shipments, :through => :so_lines

  has_many :item_alt_names, :dependent => :destroy

  accepts_nested_attributes_for :item_revisions, :allow_destroy => true

  after_initialize :default_values

  def default_values
    self.item_active = true if self.attributes.has_key?("item_active") && self.item_active.nil?
  end

  after_create :create_alt_name

  def create_alt_name
      self.item_alt_names.new(:item_alt_identifier => self.item_part_no).save(:validate => false)
  end

  after_update :update_alt_name

  def update_alt_name
      alt_names = self.item_alt_names.where("organization_id is NULL")
      alt_names.each do |alt_name|
          alt_name.item_alt_identifier = self.item_part_no
          alt_name.save(:validate => false)
      end
  end
  
  (validates_uniqueness_of :item_part_no if validates_length_of :item_part_no, :minimum => 2, :maximum => 50) if validates_presence_of :item_part_no
   
  def current_revision
      # self.item_revisions.find_by_latest_revision(true)
      self.item_revisions.order("item_revision_date desc").first
  end

  scope :item_with_recent_revisions, joins(:item_revisions).where("item_revisions.latest_revision = ?", true)

  def customer_alt_names
      self.item_alt_names.where("organization_id is not NULL")
  end

  def purchase_orders
      PoHeader.joins(:po_lines).where("po_lines.item_id = ?", self.id)
  end

  def sales_orders
      SoHeader.joins(:so_lines).where("so_lines.item_id = ?", self.id)
  end 

  def qty_on_order
      self.po_lines.sum(:po_line_quantity) - self.po_lines.sum(:po_line_shipped)
  end

  def qty_on_hand
      self.po_lines.sum(:po_line_shipped) - self.so_lines.sum(:so_line_shipped)
  end

  def current_location
      po_shipment = self.po_shipments.order(:created_at).last
      po_shipment.nil? ? "-" : po_shipment.po_shipped_unit.to_s + " - " + po_shipment.po_shipped_shelf
  end
  
end
