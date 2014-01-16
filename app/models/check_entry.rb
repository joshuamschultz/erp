class CheckEntry < ActiveRecord::Base
  attr_accessible :check_active, :check_code, :check_identifier

  validates_presence_of :check_identifier, :check_code

  validates_uniqueness_of :check_code

  def self.get_next_check_code
  		last_check = CheckEntry.order(:id).last
		next_check = CheckEntry.where("check_code not in (?)", Payment.all.collect(&:payment_check_code)).order(:id).first
		if next_check
			next_check.check_code
		elsif last_check
			last_check.check_code.next
		else
			""
		end
  end

  def check_used?
  		self.payment.present?
  end

  has_one :payment, :class_name => "Payment", :foreign_key => "payment_check_code", :primary_key => 'check_code'

end





# last_check = CheckEntry.order(:id).where(check_active: false).last
# next_check = CheckEntry.order(:id).where(check_active: true).first
# if next_check
# 	next_check.check_code
# elsif last_check
# 	last_check.check_code.next
# else
# 	""
# end