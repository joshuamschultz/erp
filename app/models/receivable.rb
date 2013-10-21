class Receivable < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
  belongs_to :so_header
  has_many :receivable_shipments, :dependent => :destroy
  has_many :receivable_lines, :dependent => :destroy
  has_many :receipt_lines, :dependent => :destroy  

  attr_accessible :receivable_active, :receivable_cost, :receivable_created_id,
  :receivable_discount, :receivable_identifier, :receivable_notes, :receivable_status, 
  :receivable_total, :receivable_updated_id, :so_header_id, :receivable_description, 
  :organization_id, :receivable_shipments_attributes

  has_many :attachments, :as => :attachable, :dependent => :destroy

  accepts_nested_attributes_for :receivable_shipments

  validates_presence_of :receivable_description, :receivable_identifier

  validates_uniqueness_of :receivable_identifier

  before_save :process_before_save

  def process_before_save
      self.organization = self.so_header.organization if self.so_header
      # self.receivable_total = self.update_receivable_total
  end

  after_save :process_after_save

  def process_after_save
      self.process_receivable_total
  end 

  before_create :process_before_create

  def process_before_create
      # self.receivable_identifier = "Invoice #{Receivable.all.count + 1}"
      self.receivable_status = "open"     
  end  

  after_create :process_after_create

  def process_after_create
      if self.so_header
          self.so_header.so_lines.each do |so_line|
            if so_line.receivable_shipments.sum(:receivable_shipment_count) < so_line.so_line_shipped #so_line.so_line_quantity
                receivable_shipment = self.receivable_shipments.build
                receivable_shipment.so_line = so_line
                receivable_shipment.receivable_shipment_count = so_line.so_line_shipped - so_line.receivable_shipments.sum(:receivable_shipment_count)
                receivable_shipment.save  
            end
          end
      end
      self.process_receivable_total
  end

  def process_receivable_total
      Receivable.skip_callback("save", :before, :process_before_save)
      Receivable.skip_callback("save", :after, :process_after_save)
      receivable_total = self.update_receivable_total
      self.update_attributes(:receivable_total => receivable_total)
      Receivable.set_callback("save", :before, :process_before_save)
      Receivable.set_callback("save", :after, :process_after_save)
  end

  def update_receivable_total
      receivable_total = self.receivable_lines.sum(:receivable_line_cost) - self.receivable_discount
      receivable_total += self.receivable_shipments.sum(:receivable_shipment_cost) if self.so_header
      receivable_total
  end

  def receivable_current_balance
      self.receivable_total - self.receipt_lines.sum(:receipt_line_amount)
  end

  def redirect_path
      receivable_path(self)
  end

end