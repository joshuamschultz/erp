class Payment < ActiveRecord::Base
    include Rails.application.routes.url_helpers

    has_many :payment_lines, :dependent => :destroy, :before_add => :set_payment
    has_one :reconcile
    has_one :deposit_check
    has_one :printing_screen
    has_many :gl_entries, :dependent => :destroy
    has_one :check_register, :dependent => :destroy

    belongs_to :organization

    attr_accessible :payment_active, :payment_check_amount, :payment_check_code, :payment_check_no,
        :payment_created_id, :payment_description, :payment_identifier, :payment_notes, :payment_status,
        :payment_type_id, :payment_updated_id, :organization_id, :payment_lines_attributes, :check_entry_id,
        :check_entry_attributes, :next_check_code, :payment_check_code_type

    accepts_nested_attributes_for :payment_lines, :reject_if => lambda { |b| b[:payment_line_amount].blank? || b[:payable_id].blank? }

    belongs_to :payment_type, :class_name => "MasterType", :foreign_key => "payment_type_id",
        :conditions => "type_category = 'payment_type' and type_name != 'cash'"

    belongs_to :check_entry #, :class_name => "CheckEntry", :foreign_key => "payment_check_code", :primary_key => 'check_code'

    validates_presence_of :organization

    scope :status_based_payments, lambda{|status| where(:payment_status => status) }

    before_validation :process_before_validation

    def process_before_validation
        if self.payment_type.present? && self.payment_type.type_value != "check"
            self.check_entry_id = nil
            self.check_entry_attributes = {}
        end
    end

    accepts_nested_attributes_for :check_entry, update_only: true, allow_destroy: true, :reject_if => lambda { |b| b[:check_code].nil? || b[:check_code].blank? }

    # validates_presence_of :payment_check_code, :if => Proc.new { |o| (o.payment_type.present? && o.payment_type.type_value == "check") }
    # validates_uniqueness_of :payment_check_code, :if => Proc.new { |o| (o.payment_type.present? && o.payment_type.type_value == "check") }

    def process_removed_lines(payment_lines)
        if payment_lines && payment_lines.any?
            payment_lines.each do |key, payment_line|
                if payment_line["payable_id"].nil?
                    line = PaymentLine.find(payment_line["id"])
                    line.destroy
                    payment_lines.delete(key)
                end
            end
        else
            payment_lines = []
        end
        payment_lines
    end

    validate :payment_total_amount

    def payment_total_amount
        payable_ids = self.payment_lines.collect(&:payable_id)
        if payable_ids.uniq != payable_ids
            errors.add(:organization_id, "have duplicate payable entries added!")
        end

        total_amount = 0
        self.payment_lines.each{|b| total_amount += b.payment_line_amount.to_f }
        self.payment_check_amount = total_amount

        if self.payment_lines.empty?
            errors.add(:payment_check_amount, "is not assigned to any PO!")
            # elsif total_amount > self.payment_check_amount
            #   errors.add(:payment_check_amount, "is not sufficient!  Total lines amount needed: #{total_amount}")
        end
    end

    before_create :process_before_create

    def process_before_create
        self.payment_identifier = CommonActions.get_new_identifier(Payment, :payment_identifier, "C")
        self.payment_status = "open"
    end

    after_save :process_after_save

    def process_after_save        
        if self.check_entry.nil? && self.payment_type.present? && self.payment_type.type_value == "check"                                     
            if self.payment_check_code_type == "Manual"                
                Reconcile.create(tag: "not reconciled", reconcile_type: self.payment_type.type_value, payment_id: self.id) if self.payment_check_code_type == "Manual"
                self.update_transactions
            else
               @check_entry = CheckEntry.new(check_active: true, check_code: self.payment_check_code, check_identifier: "Check")
               if @check_entry.save                
                self.update_attributes(:check_entry_id => @check_entry.id)
               end 
            end    
            # temp = CheckCode.find_by_counter_type("check_code")
            # temp.update_attributes(:counter => self.payment_check_code)
            # CheckCode.get_next_check_code
        end
        if self.payment_type.present? && (self.payment_type.type_value == "credit" || self.payment_type.type_value == "ach" )
            Reconcile.create(tag: "not reconciled", reconcile_type: self.payment_type.type_value, payment_id: self.id) 
            self.update_transactions # if self.payment_type.type_value == "ach"
            # payable = Payable.find (self.payment_lines.collect(&:payable_id).first)
            
            # CommonActions.update_gl_accounts('ACCOUNTS PAYABLE', 'decrement',self.payment_check_amount - payable.payable_freight )
            # CommonActions.update_gl_accounts('PETTY CASH', 'decrement',self.payment_check_amount ) 
            # CommonActions.update_gl_accounts('FREIGHT ; UPS', 'decrement',payable.payable_freight ) 
        end    
        if  self.payment_type.present? &&  self.payment_type.type_value == "ach"  || (self.payment_type.type_value == "check" && self.payment_check_code_type == "Manual")
            check_code = self.payment_check_code || nil if self.payment_check_code_type == "Manual"
            check_register = CheckRegister.where(payment_id: self.id).first
            if check_register.present?
                prev_amount = check_register.amount
                amount = self.payment_check_amount * -1 
                balance = check_register.balance - prev_amount + amount
                check_register.update_attributes(:amount => amount, :balance => balance)
            else 
                balance = 0 
                amount =  self.payment_check_amount * -1 
                gl_account = GlAccount.where('gl_account_identifier' => '11012' ).first                     
                if  CheckRegister.exists? 
                check_register = CheckRegister.last                                       
                balance += amount + check_register.balance
                else
                    balance += gl_account.gl_account_amount                         
                end          
                CheckRegister.create(transaction_date: Date.today.to_s, organization_id: self.organization_id, amount: amount, rec: false, payment_id: self.id, balance: balance, check_code: check_code)
            end
        end    
        if  self.payment_type.present? &&  self.payment_type.type_value == "credit"  
            credit_register = CreditRegister.where(payment_id: self.id).first
            unless  credit_register.present?                
                 balance = self.payment_check_amount * -1                  
                 balance += CreditRegister.calculate_balance.to_f  if  CreditRegister.exists?                                                         
                CreditRegister.create(transaction_date: Date.today.to_s, organization_id: self.organization_id, amount: self.payment_check_amount, rec: false, payment_id: self.id, balance: balance)
            end
        end 

    end

    def redirect_path
        payment_path(self)
    end


    def update_transactions       
        self.update_transaction("11012") 
        self.update_transaction("21010")
    end

    def  update_transaction(account)      
        @gl_account_to_update = GlAccount.where(:gl_account_identifier=> account).first
        @gl_account = GlAccount.where(:id => @gl_account_to_update.id).first
        @gl_entry = GlEntry.where(payment_id: self.id, gl_account_id: @gl_account_to_update.id).first
            unless @gl_entry.nil?
                @gl_entry.update_attributes(:gl_entry_debit => self.payment_check_amount)
                amount = @gl_account.gl_account_amount - self.payment_check_amount_was.to_f + self.payment_check_amount.to_f
                @gl_account.update_attributes(:gl_account_amount => amount)
            else
                desc = self.payment_type.type_name
                if self.payment_type.type_value == "check"  
                    desc = "Check "+ self.payment_check_code                
                end
                @gl_entry = GlEntry.new(:gl_account_id => @gl_account_to_update.id, :gl_entry_description => desc, :gl_entry_debit => self.payment_check_amount, :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :payment_id => self.id)
                @gl_entry.save 
                amount = @gl_account.gl_account_amount - self.payment_check_amount.to_f               
                @gl_account.update_attributes(:gl_account_amount => amount) 
            end 
    end

    private

    def set_payment(line)
        line.payment ||= self
        puts line.id
    end

end
