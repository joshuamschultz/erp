# == Schema Information
#
# Table name: receivable_accounts
#
#  id                             :integer          not null, primary key
#  receivable_id                  :integer
#  gl_account_id                  :integer
#  receivable_account_description :string(255)
#  receivable_account_amount      :decimal(25, 10)  default(0.0)
#  receivable_account_created_id  :integer
#  receivable_account_updated_id  :integer
#  created_at                     :datetime
#  updated_at                     :datetime
#  gl_entry_id                    :integer
#

class ReceivableAccount < ActiveRecord::Base
  belongs_to :receivable
  belongs_to :gl_account
  has_one :gl_entry, :dependent => :destroy


  validates_presence_of :receivable, :gl_account, :receivable_account_amount

  validates_numericality_of :receivable_account_amount

  after_save :process_after_save
  before_destroy :process_before_destory
  
  def process_after_save 
    @gl_account_to_update = GlAccount.where(:gl_account_identifier=> "11030").first
    @gl_account_id_to_update = @gl_account_to_update.id
  	if self.gl_entry_id
  		@gl_entry = GlEntry.where(:id => self.gl_entry_id, :gl_account_id => self.gl_account_id).first       
      	self.gl_account.gl_account_identifier == "51020-020" || self.gl_account.gl_account_identifier == "11050" ||  self.gl_account.gl_account_identifier == "41025-010" ? @gl_entry.update_attributes(:gl_entry_debit=> self.receivable_account_amount * -1 ) : @gl_entry.update_attributes(:gl_entry_credit => self.receivable_account_amount)  ;
    else
    	@gl_entry
    	if self.gl_account.gl_account_identifier == "51020-020" || self.gl_account.gl_account_identifier == "11050" ||  self.gl_account.gl_account_identifier == "41025-010"
    		@gl_entry = GlEntry.new(:gl_account_id => self.gl_account_id, :gl_entry_description => "Receivable " +self.receivable.receivable_identifier, :gl_entry_debit => self.receivable_account_amount * -1 , :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :receivable_id => self.receivable_id) 
    	else	
    		@gl_entry = GlEntry.new(:gl_account_id => self.gl_account_id, :gl_entry_description => "Receivable " +self.receivable.receivable_identifier, :gl_entry_credit => self.receivable_account_amount, :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :receivable_id => self.receivable_id) 	
		  end    		
    	@gl_entry.save    	
     	self.update_attributes(:gl_entry_id => @gl_entry.id)
  	end
  	receivable = Receivable.where(:id => self.receivable_id).first
    id = GlAccount.where(:gl_account_identifier=> "51020-020").first.id    
	  pacctsum =  receivable.receivable_accounts.where('gl_account_id not in (?)', [id]).sum(:receivable_account_amount).to_f  	
    pacctsum += receivable.receivable_accounts.where(:gl_account_id => id).first.receivable_account_amount * -1 if receivable.receivable_accounts.where(:gl_account_id => id).first.present?
  	@gl_entry = GlEntry.where(:receivable_id => self.receivable_id, :gl_account_id => @gl_account_id_to_update).first
  	if @gl_entry.blank?
  		@gl_entry = GlEntry.new(:gl_account_id => @gl_account_id_to_update, :gl_entry_description => "Receivable " +self.receivable.receivable_identifier, :gl_entry_credit => pacctsum , :gl_entry_active => 1, :gl_entry_date => Date.today.to_s, :receivable_account_id => self.id, :receivable_id => self.receivable_id)  		
      @gl_entry.save   	
    else
    	@gl_entry.update_attributes(:gl_entry_credit => pacctsum )
  	end
  	@gl_account = GlAccount.where(:id => self.gl_account_id).first
  	@amount
  	if  self.gl_account.gl_account_identifier == "11050"||  self.gl_account.gl_account_identifier == "41025-010"
      @amount = @gl_account.gl_account_amount - self.receivable_account_amount_was.to_f * -1 + self.receivable_account_amount.to_f * -1
  	else
    	@amount = @gl_account.gl_account_amount - self.receivable_account_amount_was.to_f  + self.receivable_account_amount.to_f
	end    	 
    # @gl_account.update_attributes(:gl_account_amount => @amount) unless @gl_account.gl_account_identifier == '41010-010' || @gl_account.gl_account_identifier == '51010-010'
    @gl_account = GlAccount.where(:id => @gl_account_id_to_update).first
    amount = @gl_account.gl_account_amount - self.receivable_account_amount_was.to_f + self.receivable_account_amount.to_f
    @gl_account.update_attributes(:gl_account_amount => amount)   
  end

  def process_before_destory
  	@gl_entry = GlEntry.where(:id => self.gl_entry_id_was).first 
    # amount = @gl_entry.gl_entry_credit    
  	# CommonActions.update_gl_accounts_for_gl_entry(@gl_entry.gl_account.gl_account_title, 'decrement', @gl_entry.gl_entry_credit)
    @gl_entry.destroy if @gl_entry  	
  end  
end
