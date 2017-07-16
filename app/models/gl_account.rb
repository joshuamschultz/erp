# == Schema Information
#
# Table name: gl_accounts
#
#  id                     :integer          not null, primary key
#  gl_type_id             :integer
#  gl_account_title       :string(255)
#  gl_account_identifier  :string(255)
#  gl_account_description :string(255)
#  gl_account_active      :boolean
#  created_at             :datetime
#  updated_at             :datetime
#  gl_account_amount      :decimal(15, 10)  default(0.0)
#  key_account            :boolean          default(TRUE)
#

class GlAccount < ActiveRecord::Base
  

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

  (validates_uniqueness_of :gl_account_identifier if validates_length_of :gl_account_identifier, :minimum => 2, :maximum => 20) if validates_presence_of(:gl_account_identifier)
  (validates_uniqueness_of :gl_account_title if validates_length_of :gl_account_title, :minimum => 2, :maximum => 40) if validates_presence_of :gl_account_title
  validates_presence_of :gl_type

  def credit_total
    self.gl_entries.sum(:gl_entry_credit)
  end 

  def debit_total
    self.gl_entries.sum(:gl_entry_debit)
  end

  def total_amount
    amount = credit_total - debit_total
    self.update_attributes(:gl_account_amount => amount)
  end    
end
