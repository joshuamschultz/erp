class GlEntry < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :gl_account
  belongs_to :payable
  belongs_to :payable_account
  belongs_to :receivable_account
  has_one :payment


  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  attr_accessible :gl_entry_active, :gl_entry_credit, :gl_entry_date, :gl_entry_debit, 
  :gl_entry_description, :gl_entry_identifier, :gl_entry_notes, :gl_account_id, :payable_id, :payable_account_id, :receivable_id, :receivable_account_id, :payment_id, :receipt_id

  validates_presence_of :gl_entry_description, :gl_account

  before_create :process_before_create
 # after_save :process_after_save
  before_destroy :process_before_destory

  def process_before_create
      self.gl_entry_identifier = CommonActions.get_new_identifier(GlEntry, :gl_entry_identifier)
  end

   def process_before_destory
     if self.gl_entry_debit_was != 0
       CommonActions.update_gl_accounts_for_gl_entry(self.gl_account.gl_account_title_was, 'decrement', self.gl_entry_debit_was)
     end
     if self.gl_entry_credit_was != 0
       CommonActions.update_gl_accounts_for_gl_entry(self.gl_account.gl_account_title_was, 'decrement', self.gl_entry_credit_was)
     end
   end

  

  def redirect_path
     gl_entry_path(self)
  end

end
