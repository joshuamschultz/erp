class Receivable < ActiveRecord::Base  
  include Rails.application.routes.url_helpers
  
  attr_accessible :receivable_active, :receivable_cost, :receivable_created_id,
  :receivable_discount, :receivable_identifier, :receivable_notes, :receivable_status, 
  :receivable_total, :receivable_updated_id, :so_header_id, :receivable_description, 
  :organization_id, :receivable_shipments_attributes, :receivable_invoice, :gl_account_id,
  :receivable_accounts_attributes

  scope :status_based_receivables, lambda{|status| where(:receivable_status => status) }

  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("customer").id]
  belongs_to :so_header
  belongs_to :gl_account

  has_many :receivable_shipments, :dependent => :destroy
  has_many :receivable_lines, :dependent => :destroy
  has_many :receipt_lines, :dependent => :destroy
  has_many :receivable_so_shipments, :dependent => :destroy
  has_many :so_shipments, through: :receivable_so_shipments
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :receivable_accounts, :dependent => :destroy

  accepts_nested_attributes_for :receivable_shipments
  accepts_nested_attributes_for :receivable_accounts

  validates_presence_of :receivable_invoice, :organization
  # validates_presence_of :receivable_identifier, :if => Proc.new { |o| o.so_header.nil? }
  # validates_uniqueness_of :receivable_identifier

  validate :validate_receivable_account_total, on: :update

  def validate_receivable_account_total
      gl_account_ids = self.receivable_accounts.collect(&:gl_account_id)
      if gl_account_ids.uniq != gl_account_ids 
          errors.add(:receivable_invoice, "have duplicate account entries added!")
      end

      total_amount = 0
      self.receivable_accounts.each{|b| total_amount += b.receivable_account_amount.to_f }

      errors.add(:receivable_invoice, "total (#{self.receivable_total}) < dispersed account total (#{total_amount})") if total_amount > self.receivable_total
  end

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
      self.receivable_identifier = CommonActions.get_new_identifier(Receivable, :receivable_identifier)
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
      receivable_total = self.receivable_lines.sum(:receivable_line_cost)
      receivable_total += self.so_shipments.sum(:so_shipped_cost) if self.so_header
      receivable_discount_val = (receivable_total / 100) * self.receivable_discount rescue 0
      receivable_total - receivable_discount_val
  end

  def receivable_current_balance
      self.receivable_total - self.receipt_lines.sum(:receipt_line_amount)
  end

  def redirect_path
      receivable_path(self)
  end

  def check_receivable_account_total
      (self.receivable_accounts.sum(:receivable_account_amount) == self.receivable_total) ? "" : "(<strong style='color: red'>Mismatch b/w Receivable and Account Total)</strong>)".html_safe
  end

end