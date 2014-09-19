class PoLine < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :po_header
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
  belongs_to :so_line
  belongs_to :vendor_quality
  belongs_to :customer_quality
  belongs_to :item
  belongs_to :item_revision
  belongs_to :item_selected_name
  belongs_to :item_alt_name

  attr_accessible :po_line_active, :po_line_cost, :po_line_created_id, :po_line_customer_po, 
  :po_line_notes, :po_line_quantity, :po_line_status, :po_line_total, :po_line_updated_id,
  :po_header_id, :organization_id, :so_line_id, :vendor_quality_id, :customer_quality_id,
  :item_id, :item_revision_id, :item_selected_name_id, :item_alt_name_id, :po_line_shipped,
  :alt_name_transfer_id, :po_line_sell

  has_many :quality_lots, :dependent => :destroy
  has_many :payable_shipments, :dependent => :destroy
  has_many :po_shipments, :dependent => :destroy
  has_one :quote_line
  has_many :checklists

  belongs_to :item_transfer_name, :foreign_key => "alt_name_transfer_id", :class_name => "ItemAltName"

  validates_presence_of :item_alt_name_id
  validates_presence_of :po_header, :item_alt_name, :po_line_cost, :po_line_quantity
  validates_numericality_of :po_line_cost

  validates_numericality_of :po_line_quantity, greater_than: 0

  validates_numericality_of :po_line_sell, :if => Proc.new { |o| o.po_header.present? && o.po_header.customer.present? }

  before_create :create_level_default

  def create_level_default
    self.po_line_status = "open"
    if self.po_header.po_is?("direct")
        self.organization = self.po_header.customer
        self.po_line_customer_po = self.po_header.cusotmer_po
    end
  end

  def after_commit_process 
    html = "#{root_url}/po_headers/#{self.po_header.id}/purchase_report"
      kit = PDFKit.new(html, :page_size => 'A4' )  
      # Get an inline PDF
      pdf = kit.to_pdf
      # Save the PDF to a file    
      path = Rails.root.to_s+"/public/purchase_report"
      if File.directory? path
        path = path+"/"+self.po_header.po_identifier.to_s+".pdf"
        kit.to_file(path)
      else
        Dir.mkdir path
        path = path+"/"+self.po_header.po_identifier.to_s+".pdf"
        kit.to_file(path)
      end

  end

  before_save :update_item_total

  def update_item_total
    self.po_line_total = self.po_line_cost * self.po_line_quantity
    self.item = self.item_alt_name.item
    self.item_revision = self.item_alt_name.item.current_revision
  end

  after_save :update_po_total
  after_destroy :update_po_total

  def update_po_total
    po_identifier = (self.po_header.po_identifier == UNASSIGNED) ? PoHeader.new_po_identifier : self.po_header.po_identifier

    self.po_header.update_attributes(po_identifier: po_identifier, po_total: self.po_header.po_lines.sum(:po_line_total))
    after_commit_process
  end

  def po_line_item_name
    self.item_alt_name.alt_item_name
  end

  def po_line_data_list(object, shipment)
    po_line = shipment ? object.po_line : object
    object[:po_identifier] = CommonActions.linkable(po_header_path(po_line.po_header), po_line.po_header.po_identifier)
    object[:item_part_no] = CommonActions.linkable(item_path(po_line.item), po_line.item_alt_name.item_alt_identifier)
    object[:vendor_name] = (CommonActions.linkable(organization_path(po_line.po_header.organization), po_line.po_header.organization.organization_name) if po_line.po_header.organization) || ""
    object[:customer_name] = (CommonActions.linkable(organization_path(po_line.organization), po_line.organization.organization_name) if po_line.organization) || ""
    object[:quality_level_name] = (CommonActions.linkable(customer_quality_path(po_line.organization.customer_quality), po_line.organization.customer_quality.quality_name) if po_line.organization && po_line.organization.customer_quality) || ""
    object[:quality_id_name] = (CommonActions.linkable(customer_quality_path(po_line.po_header.organization.vendor_quality), po_line.po_header.organization.vendor_quality.quality_name) if po_line.po_header.organization && po_line.po_header.organization.vendor_quality) || ""
    object[:po_line_quantity] = po_line.po_line_quantity      
    object[:po_line_quantity_shipped] = "<div class='po_line_shipping_total'>#{po_line.po_line_shipped}</div>"
    object[:po_line_quantity_open] = "<div class='po_line_quantity_open'>#{po_line.po_line_quantity - po_line.po_line_shipped}</div>"
    unless shipment
      object[:po_line_shipping] = "<div class='po_line_shipping_input'><input po_line_id='#{po_line.id}' po_shipped_status='received' class='shipping_input_field shipping_input_po_#{po_line.po_header.id}' type='text' value='0'></div>"
      object[:po_line_shelf] = "<div class='po_line_shelf_input'><input type='text'></div>"
      object[:po_line_unit] =  "<div class='po_line_unit_input'><input type='text'></div>"
      object[:po_identifier] += "<a onclick='process_all_open(#{po_line.po_header.id}, $(this)); return false' class='pull-right btn btn-small btn-success' href='#'>Receive All</a>"
      object[:po_identifier] += "<a onclick='fill_po_items(#{po_line.po_header.id}); return false' class='pull-right btn btn-small btn-success' href='#'>Fill</a>"
      
      object[:links] = "<a po_line_id='#{po_line.id}' po_shipped_status='rejected' class='pull-right btn_save_shipped btn-action glyphicons ban btn-danger' href='#'><i></i></a> "
      object[:links] += " <a po_line_id='#{po_line.id}' po_shipped_status='on hold' class='pull-right btn_save_shipped btn-action glyphicons circle_exclamation_mark btn-warning' href='#'><i></i></a> "
      object[:links] += " <a po_line_id='#{po_line.id}' po_shipped_status='received' class='pull-right btn_save_shipped btn-action glyphicons check btn-success' href='#'><i></i></a> "
      object[:links] += " <div class='pull-right shipping_status'></div>"
    end
    object
  end

  before_save :process_before_save

  def process_before_save
      if self.po_header.po_is?("direct")
          so_line = self.so_line.present? ? self.so_line : SoLine.new
          so_line.update_attributes(so_header_id: self.po_header.so_header_id, item_alt_name_id: self.item_alt_name_id, 
            customer_quality_id: self.po_header.customer.customer_quality_id, so_line_cost: self.po_line_cost, 
            so_line_sell: self.po_line_sell, so_line_quantity: self.po_line_quantity, organization_id: self.po_header.organization_id)
          self.so_line_id = so_line.id
      end
  end


  def po_customer
      self.po_header.po_is?("direct") ? self.po_header.customer : self.organization
  end

end
