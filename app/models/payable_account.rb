# == Schema Information
#
# Table name: payable_accounts
#
#  id                          :integer          not null, primary key
#  payable_id                  :integer
#  gl_account_id               :integer
#  payable_account_description :string(255)
#  payable_account_amount      :decimal(25, 10)  default(0.0)
#  payable_account_created_id  :integer
#  payable_account_updated_id  :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  gl_entry_id                 :integer
#

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
    @gl_account_to_update = GlAccount.where(:gl_account_identifier=> "21010").first
    @gl_account_id_to_update = @gl_account_to_update.id
    amount_tosave = self.payable_account_amount.to_f
    if self.payable_account_amount.to_f < 0 
      amount_tosave *= -1
    end
    @gl_entry
  	if self.gl_entry_id
  		@gl_entry = GlEntry.where(:id => self.gl_entry_id, :gl_account_id => self.gl_account_id).first                   
    else
    	@gl_entry = GlEntry.new(:gl_account_id => self.gl_account_id, :gl_entry_description => "Payable "+self.payable.payable_identifier,  :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :payable_id => self.payable_id) 	
    	@gl_entry.save      
     	self.update_attributes(:gl_entry_id => @gl_entry.id)
  	end
    if  self.payable_account_amount.to_f < 0 &&   @gl_entry.gl_account_id  != @gl_account_id_to_update
        @gl_entry.update_attributes(:gl_entry_debit => amount_tosave)
    else
        @gl_entry.update_attributes(:gl_entry_credit => amount_tosave)  
    end
  	payable = Payable.where(:id => self.payable_id).first
  	pacctsum =  payable.payable_accounts.sum(:payable_account_amount).to_f  	
  	@gl_entry = GlEntry.where(:payable_id => self.payable_id, :gl_account_id => @gl_account_id_to_update).first
  	if @gl_entry.blank?
  		@gl_entry = GlEntry.new(:gl_account_id => @gl_account_id_to_update, :gl_entry_description => "Payable "+self.payable.payable_identifier, :gl_entry_credit => pacctsum , :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :payable_account_id => self.id, :payable_id => self.payable_id)  		
      @gl_entry.save   	
    else
    	@gl_entry.update_attributes(:gl_entry_credit => pacctsum )
  	end
  	@gl_account = GlAccount.where(:id => self.gl_account_id).first
    amount = @gl_account.gl_account_amount - self.payable_account_amount_was.to_f + self.payable_account_amount.to_f
    # @gl_account.update_attributes(:gl_account_amount => amount)
    @gl_account = GlAccount.where(:id => @gl_account_id_to_update).first
    amount = @gl_account.gl_account_amount - self.payable_account_amount_was.to_f + self.payable_account_amount.to_f
    @gl_account.update_attributes(:gl_account_amount => amount)   
  end

  def process_before_destory
  	@gl_entry = GlEntry.where(:id => self.gl_entry_id_was).first
    amount = @gl_entry.gl_entry_credit    
  	# CommonActions.update_gl_accounts_for_gl_entry(@gl_entry.gl_account.gl_account_title, 'decrement', @gl_entry.gl_entry_credit)
    @gl_entry.destroy     	
  end  

end
