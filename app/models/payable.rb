class Payable < ActiveRecord::Base
  
  include Rails.application.routes.url_helpers  

  attr_accessible :payable_active, :payable_cost, :payable_created_id, :payable_description, 
  :payable_discount, :payable_due_date, :payable_identifier, :payable_invoice_date, 
  :payable_notes, :payable_status, :payable_to_id, :payable_total, :payable_updated_id,
  :organization_id, :po_header_id, :payable_freight, :po_shipments_attributes, :payable_invoice, 
  :gl_account_id, :payable_accounts_attributes

  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("vendor").id]
  belongs_to :po_header
  belongs_to :gl_account
  belongs_to :payable_to_address, :class_name => "Contact", :foreign_key => "payable_to_id", 
	:conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  has_many :payable_lines, :dependent => :destroy
  has_many :payment_lines, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :payable_po_shipments, :dependent => :destroy
  has_many :po_shipments, through: :payable_po_shipments
  has_many :payable_accounts, :dependent => :destroy

  accepts_nested_attributes_for :po_shipments
  accepts_nested_attributes_for :payable_accounts

  validates_presence_of :payable_invoice_date, :payable_due_date, :organization, :payable_invoice
  # validates_presence_of :payable_invoice, on: :update
  # validates_presence_of :payable_identifier, :if => Proc.new { |o| o.po_header.nil? }
  # validates_uniqueness_of :payable_identifier

  validate :validate_payable_account_total, on: :update

  def validate_payable_account_total
      gl_account_ids = self.payable_accounts.collect(&:gl_account_id)
      if gl_account_ids.uniq != gl_account_ids 
          errors.add(:payable_invoice, "have duplicate account entries added!")
      end

      total_amount = 0
      self.payable_accounts.each{|b| total_amount += b.payable_account_amount.to_f }

      errors.add(:payable_invoice, "total (#{self.payable_total}) < dispersed account total (#{total_amount})") if total_amount > self.payable_total
  end

  def process_removed_accounts(payable_accounts)
      if payable_accounts && payable_accounts.any?
          payable_accounts.each do |key, payable_account|
              if payable_account["gl_account_id"].nil?
                account = PayableAccount.find(payable_account["id"])
                account.destroy
                payable_accounts.delete(key)
              end
          end
      else
          payable_accounts = []
      end
      payable_accounts
  end

  before_save :process_before_save

  def process_before_save
      self.organization = self.po_header.organization if self.po_header
  		# self.payable_total = self.update_payable_total
  end

  after_save :process_after_save

  def process_after_save
      self.process_payable_total
  end 

  before_create :process_before_create

  def process_before_create
      self.payable_identifier = CommonActions.get_new_identifier(Payable, :payable_identifier)
      self.payable_status = "open"     
  end  

  def process_payable_total
      Payable.skip_callback("save", :before, :process_before_save)
      Payable.skip_callback("save", :after, :process_after_save)
      self.payable_total = self.update_payable_total
      self.save(validate: false)
      # self.update_attributes(:payable_total => payable_total)
      Payable.set_callback("save", :before, :process_before_save)
      Payable.set_callback("save", :after, :process_after_save)
  end

  def update_payable_total
      payable_total = self.payable_lines.sum(:payable_line_cost)
      payable_total += self.po_shipments.sum(:po_shipped_cost) if self.po_header
      payable_discount_val = (payable_total / 100) * self.payable_discount rescue 0
      payable_total - payable_discount_val
  end

  def payable_current_balance
      self.payable_total - self.payment_lines.sum(:payment_line_amount)
  end

  def redirect_path
      payable_path(self)
  end

  def check_payable_account_total
      (self.payable_accounts.sum(:payable_account_amount) == self.payable_total) ? "" : "(<strong style='color: red'>Mismatch b/w Payable and Account Total)</strong>)".html_safe
  end

end
