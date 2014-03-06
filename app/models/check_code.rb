class CheckCode < ActiveRecord::Base
	attr_accessible :next_check_code

	def self.get_next_check_code
		temp = CheckCode.first.next_check_code
		CheckCode.first.update_attributes(:next_check_code => temp.next)
		temp
	end
end