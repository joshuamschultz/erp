class PayableAccount < ActiveRecord::Base
  belongs_to :payable
  belongs_to :gl_account
  
  attr_accessible :payable_id, :gl_account_id, :payable_account_amount, :payable_account_created_id, 
  :payable_account_description, :payable_account_updated_id

  validates_presence_of :payable, :gl_account, :payable_account_amount

  validates_numericality_of :payable_account_amount, greater_than: 0

  validate :validate_payable_account_total

  def validate_payable_account_total
  	payable_account_total = self.persisted? ? self.payable.payable_accounts.where("id != ?", self.id).sum(:payable_account_amount) : self.payable.payable_accounts.sum(:payable_account_amount)
  	
  	p "*******************"
  	p "*******************"
  	p "*******************"
  	p payable_account_total.to_f
  	p "*******************"
  	p "*******************"
  	p "*******************"

  	errors.add(:payable_account_amount, "exceeds than payable amount #{self.payable.payable_total}") if (payable_account_total + self.payable_account_amount) > self.payable.payable_total
  end

end
