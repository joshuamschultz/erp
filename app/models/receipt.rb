class Receipt < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :receipt_lines, :dependent => :destroy, :before_add => :set_receipt
  belongs_to :organization
  has_one :reconcile
  has_one :deposit_check, :dependent => :destroy
  has_one :check_register

  attr_accessible :receipt_active, :receipt_check_amount, :receipt_check_code, :receipt_check_no,
    :receipt_created_id, :receipt_description, :receipt_identifier, :receipt_notes, :receipt_status,
    :receipt_type_id, :receipt_updated_id, :organization_id, :receipt_lines_attributes, :deposit_check_id, :receipt_discount

  scope :status_based_receipts, lambda{|status| where(:receipt_status => status) }

  accepts_nested_attributes_for :receipt_lines, :reject_if => lambda { |b| b[:receipt_line_amount].blank? || b[:receivable_id].blank? }

  belongs_to :receipt_type, :class_name => "MasterType", :foreign_key => "receipt_type_id", :conditions => ['type_category = ?', 'payment_type']

  # belongs_to :check_entry, :class_name => "CheckEntry", :foreign_key => "receipt_check_code", :primary_key => 'check_code'

  validates_presence_of :organization

  def process_removed_lines(receipt_lines)
    if receipt_lines && receipt_lines.any?
      receipt_lines.each do |key, receipt_line|
        if receipt_line["receivable_id"].nil?
          line = ReceiptLine.find(receipt_line["id"])
          line.destroy
          receipt_lines.delete(key)
        end
      end
    else
      receipt_lines = []
    end
    receipt_lines
  end

  validate :receipt_total_amount

  def receipt_total_amount
    receivable_ids = self.receipt_lines.collect(&:receivable_id)
    if receivable_ids.uniq != receivable_ids
      errors.add(:organization_id, "have duplicate receivable entries added!")
    end

    total_amount = 0
    self.receipt_lines.each{|b| total_amount += b.receipt_line_amount.to_f }
    self.receipt_check_amount = total_amount

    if self.receipt_lines.empty?
      errors.add(:receipt_check_amount, "is not assigned to any SO!")

      # elsif total_amount > self.receipt_check_amount
      #   errors.add(:receipt_check_amount, "is not sufficient!  Total line amount needed: #{total_amount}")
    end
  end

  before_create :process_before_create

  def process_before_create
    self.receipt_identifier = CommonActions.get_new_identifier(Receipt, :receipt_identifier, "R")
    self.receipt_status = "open"
  end
  
  after_save :process_after_save

  def process_after_save
    if self.receipt_type.present? &&  self.receipt_type.type_value == "check"     
            @deposit_check = DepositCheck.where(:receipt_id => self.id).first
            if @deposit_check.nil? 
              # if self.receipt_type.type_value == "check"
               depositCheck = DepositCheck.create(receipt_id: self.id, status: "open", receipt_type: self.receipt_type.type_value, check_identifier:  self.receipt_check_code, active: 1) 
              # elsif self.receipt_type.type_value == "credit" || self.receipt_type.type_value == "cash" || self.receipt_type.type_value == "ach"
                # depositCheck = DepositCheck.create(receipt_id: self.id, status: "open", receipt_type: self.receipt_type.type_value, active: 1 )       
            end              
            # end     
    elsif self.receipt_type.present? &&  self.receipt_type.type_value == "ach" ||  self.receipt_type.type_value == "cash" ||  self.receipt_type.type_value == "credit"  
        
        if self.receipt_type.type_value == "credit"  
            credit_register = CreditRegister.where(receipt_id: self.id).first
            unless  credit_register.present?                
                 balance = self.receipt_check_amount * -1                  
                 balance += CreditRegister.calculate_balance('receipt').to_f  if  CreditRegister.exists?                                                         
                CreditRegister.create(transaction_date: Date.today.to_s, organization_id: self.organization_id, amount: self.receipt_check_amount, rec: false, receipt_id: self.id, balance: balance)
            end
        end 

      self.update_transactions
      Reconcile.create(tag: "not reconciled",reconcile_type: self.receipt_type.type_value, receipt_id: self.id)          
      # self.update_transactions if self.receipt_type.type_value != "credit"       
    end
  end 

  def redirect_path
    receipt_path(self)
  end

  def update_transactions   
        self.update_transaction("11010","credit") # Cash
        self.update_transaction("11030", "debit")  # Receivable
        self.update_transaction("41025-010", "discount")  # Discount
  end

   def  update_transaction(account, type)      
        @gl_account_to_update = GlAccount.where(:gl_account_identifier=> account).first              
        @gl_account = GlAccount.where(:id => @gl_account_to_update.id).first        
        @gl_entry = GlEntry.where(receipt_id: self.id, gl_account_id: @gl_account_to_update.id).first

        amount = 0
           unless @gl_entry.nil?                
                if type == "debit"                  
                  @gl_entry.update_attributes(:gl_entry_debit => self.receipt_check_amount.to_f + self.receipt_discount.to_f)
                  amount = @gl_account.gl_account_amount - (self.receipt_check_amount_was.to_f + self.receipt_discount_was.to_f) + (self.receipt_check_amount.to_f + self.receipt_discount.to_f)
                elsif type == "credit"  
                  @gl_entry.update_attributes(:gl_entry_credit => self.receipt_check_amount.to_f )
                  amount = @gl_account.gl_account_amount - self.receipt_check_amount_was.to_f  + self.receipt_check_amount.to_f                                            
                elsif type == "discount"  
                  #@gl_entry.update_attributes(:gl_entry_debit => ((self.receipt_check_amount * 100 ).to_f / (100 - self.receipt_discount).to_f).to_f  -   self.receipt_check_amount.to_f)
                  #amount = @gl_account.gl_account_amount - (((self.receipt_check_amount_was * 100 ).to_f / (100 - self.receipt_discount_was).to_f).to_f  -   self.receipt_check_amount_was.to_f) + (((self.receipt_check_amount * 100 ).to_f / (100 - self.receipt_discount).to_f).to_f  -   self.receipt_check_amount.to_f)  
                  tot_dis =0
                  self.receipt_lines.each do |receipt_line|
                    tot_dis + ((receipt_line.receipt_line_amount * self.receipt_discount)/100).round(2)
                  end
                  tot_dis_was =0
                  self.receipt_lines.each do |receipt_line|
                    tot_dis + ((receipt_line.receipt_line_amount_was * self.receipt_discount_was)/100).round(2)
                  end
                  @gl_entry.update_attributes(:gl_entry_debit => tot_dis )
                  amount = @gl_account.gl_account_amount + tot_dis_was- tot_dis           
                end  
                @gl_account.update_attributes(:gl_account_amount => amount)
            else                
                desc = self.receipt_type.type_name
                if self.receipt_type.type_value == "check"  
                    desc = "Deposit "+ self.receipt_check_code               
                end
                if type == "debit"
                  @gl_entry = GlEntry.new(:gl_account_id => @gl_account_to_update.id, :gl_entry_description => desc, :gl_entry_debit => (self.receipt_check_amount +  self.receipt_discount), :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :receipt_id => self.id)                             
                  amount = @gl_account.gl_account_amount - (self.receipt_check_amount +  self.receipt_discount).to_f                  
                elsif type == "credit"    
                  @gl_entry = GlEntry.new(:gl_account_id => @gl_account_to_update.id, :gl_entry_description => desc, :gl_entry_credit => self.receipt_check_amount , :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :receipt_id => self.id) 
                  amount = @gl_account.gl_account_amount + self.receipt_check_amount.to_f 
                elsif type == "discount"
                    tot_dis =0
                    self.receipt_lines.each do |receipt_line|
                      tot_dis + ((receipt_line.receipt_line_amount * self.receipt_discount)/100).round(2)
                    end
                   @gl_entry= GlEntry.new(:gl_account_id => @gl_account_to_update.id, :gl_entry_description => desc, :gl_entry_debit => tot_dis, :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :receipt_id => self.id)
                   amount = @gl_account.gl_account_amount - tot_dis 
                end  
                @gl_entry.save 
                @gl_account.update_attributes(:gl_account_amount => amount) 
            end 
               Receipt.skip_callback("save", :after, :process_after_save)
               self.update_attributes(:receipt_status => 'closed')       
  end



  private

  def set_receipt(line)
    line.receipt ||= self
  end

end
