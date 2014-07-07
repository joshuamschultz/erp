class GlAccount < ActiveRecord::Base
  attr_accessible :gl_account_active, :gl_account_description, :gl_account_title, 
  :gl_account_identifier, :gl_type_id, :gl_account_amount, :key_account

  belongs_to :gl_type

  has_many :payables, dependent: :destroy
  has_many :receivables, dependent: :destroy
  has_many :gl_entries, dependent: :destroy
  has_many :payable_accounts, :dependent => :destroy
  has_many :receivable_accounts, :dependent => :destroy

  after_initialize :default_values

  def default_values
    self.gl_account_active = true if self.attributes.has_key?("gl_account_active") && self.gl_account_active.nil?
  end

  (validates_uniqueness_of :gl_account_identifier if validates_length_of :gl_account_identifier, :minimum => 2, :maximum => 20) if validates_numericality_of(:gl_account_identifier) && validates_presence_of(:gl_account_identifier)
  (validates_uniqueness_of :gl_account_title if validates_length_of :gl_account_title, :minimum => 2, :maximum => 20) if validates_presence_of :gl_account_title
  validates_presence_of :gl_type
end
