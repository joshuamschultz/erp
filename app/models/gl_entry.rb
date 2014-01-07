class GlEntry < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :gl_account

  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  attr_accessible :gl_entry_active, :gl_entry_credit, :gl_entry_date, :gl_entry_debit, 
  :gl_entry_description, :gl_entry_identifier, :gl_entry_notes, :gl_account_id

  validates_presence_of :gl_entry_description, :gl_account

  before_create :process_before_create

  def process_before_create
      self.gl_entry_identifier = CommonActions.get_new_identifier(GlEntry, :gl_entry_identifier)
  end

  def redirect_path
     gl_entry_path(self)
  end

end
