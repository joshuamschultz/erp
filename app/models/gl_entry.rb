class GlEntry < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :gl_account
  belongs_to :payable

  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  attr_accessible :gl_entry_active, :gl_entry_credit, :gl_entry_date, :gl_entry_debit, 
  :gl_entry_description, :gl_entry_identifier, :gl_entry_notes, :gl_account_id, :payable_id

  validates_presence_of :gl_entry_description, :gl_account

  before_create :process_before_create
  after_save :process_after_save

  def process_before_create
      self.gl_entry_identifier = CommonActions.get_new_identifier(GlEntry, :gl_entry_identifier)
  end

  def process_after_save
    if self.gl_entry_credit
      CommonActions.update_gl_accounts_for_gl_entry(self.gl_account.gl_account_title, 'increment', self.gl_entry_credit)
    end
    if self.gl_entry_debit
      CommonActions.update_gl_accounts_for_gl_entry(self.gl_account.gl_account_title, 'decrement', self.gl_entry_debit)
    end
  end

  def redirect_path
     gl_entry_path(self)
  end

end
