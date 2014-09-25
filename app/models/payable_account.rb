class PayableAccount < ActiveRecord::Base
  belongs_to :payable
  belongs_to :gl_account
  has_one :gl_entry, :dependent => :destroy
  
  attr_accessible :payable_id, :gl_account_id, :payable_account_amount, :payable_account_created_id, 
  :payable_account_description, :payable_account_updated_id, :gl_entry_id

  validates_presence_of :payable, :gl_account, :payable_account_amount

  validates_numericality_of :payable_account_amount

  after_save :process_after_save
  before_destroy :process_before_destory
  
  def process_after_save
  	if self.gl_entry_id
  		@gl_entry = GlEntry.where(:id => self.gl_entry_id, :gl_account_id => self.gl_account_id).first       
      @gl_entry.update_attributes(:gl_entry_credit => self.payable_account_amount)        
    else
    	@gl_entry = GlEntry.new(:gl_account_id => self.gl_account_id, :gl_entry_description => "Transaction", :gl_entry_credit => self.payable_account_amount, :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :payable_id => self.payable_id) 	
    	@gl_entry.save    	
     	self.update_attributes(:gl_entry_id => @gl_entry.id)
  	end
  	payable = Payable.where(:id => self.payable_id).first
  	pacctsum =  payable.payable_accounts.sum(:payable_account_amount).to_f  	
  	@gl_entry = GlEntry.where(:payable_id => self.payable_id, :gl_account_id => 24).first
  	if @gl_entry.blank?
  		@gl_entry = GlEntry.new(:gl_account_id => 24, :gl_entry_description => "Transaction", :gl_entry_credit => pacctsum , :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :payable_account_id => self.id, :payable_id => self.payable_id)  		
      @gl_entry.save   	
    else
    	@gl_entry.update_attributes(:gl_entry_credit => pacctsum )
  	end
  	@gl_account = GlAccount.where(:id => self.gl_account_id).first
    amount = @gl_account.gl_account_amount - self.payable_account_amount_was.to_f + self.payable_account_amount.to_f
    @gl_account.update_attributes(:gl_account_amount => amount)
    @gl_account = GlAccount.where(:id => 24).first
    amount = @gl_account.gl_account_amount - self.payable_account_amount_was.to_f + self.payable_account_amount.to_f
    @gl_account.update_attributes(:gl_account_amount => amount)   
  end

  def process_before_destory
  	@gl_entry = GlEntry.where(:id => self.gl_entry_id_was).first
    amount = @gl_entry.gl_entry_credit
    p "================================="    
    p @gl_entry.gl_account.gl_account_title
    p "==================================="
  	# CommonActions.update_gl_accounts_for_gl_entry(@gl_entry.gl_account.gl_account_title, 'decrement', @gl_entry.gl_entry_credit)
    @gl_entry.destroy     	
  end  

end
