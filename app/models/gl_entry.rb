# == Schema Information
#
# Table name: gl_entries
#
#  id                    :integer          not null, primary key
#  gl_entry_identifier   :string(255)
#  gl_account_id         :integer
#  gl_entry_description  :string(255)
#  gl_entry_date         :date             default(Wed, 21 Jun 2017)
#  gl_entry_credit       :decimal(25, 10)  default(0.0)
#  gl_entry_debit        :decimal(25, 10)  default(0.0)
#  gl_entry_notes        :text(65535)
#  gl_entry_active       :boolean          default(TRUE)
#  created_at            :datetime
#  updated_at            :datetime
#  payable_id            :integer
#  payable_account_id    :integer
#  receivable_account_id :integer
#  receivable_id         :integer
#  payment_id            :integer
#  receipt_id            :integer
#

class GlEntry < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :gl_account
  belongs_to :payable
  belongs_to :payable_account
  belongs_to :receivable_account
  has_one :payment


  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  

  validates_presence_of :gl_entry_description, :gl_account

  before_create :process_before_create
  after_save :process_after_save
  before_destroy :process_before_destory

  def process_before_create    
      self.gl_entry_identifier = CommonActions.get_new_identifier(GlEntry, :gl_entry_identifier, "A")
  end


   def process_before_destory
     update_gl_accounts(self.gl_entry_debit_was, self.gl_entry_credit_was)
   end

   def update_gl_accounts(debit, credit)
    if debit != 0
      CommonActions.update_gl_accounts_for_gl_entry(self.gl_account.gl_account_title_was, 'increment', debit)
    end

    if credit != 0
      CommonActions.update_gl_accounts_for_gl_entry(self.gl_account.gl_account_title_was, 'decrement', credit)
    end
   end
   
   def get_description_link 
    result = self.gl_entry_description
    if self.receivable_id
      result = CommonActions.linkable(receivable_path(self.receivable_id), self.gl_entry_description)
    elsif self.payable_id
      result = CommonActions.linkable(payable_path(self.payable_id), self.gl_entry_description)
    elsif self.payment_id
      result = CommonActions.linkable(payment_path(self.payment_id), self.gl_entry_description)
    elsif self.receipt_id
      result = CommonActions.linkable(receipt_path(self.receipt_id), self.gl_entry_description)
    end
    result      
   end

  def redirect_path
     gl_entry_path(self)
  end

  def process_after_save
    self.gl_account.total_amount
  end

end
