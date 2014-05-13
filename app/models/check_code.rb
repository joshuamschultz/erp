class CheckCode < ActiveRecord::Base
	attr_accessible :counter, :counter_type

	def self.get_next_check_code
		temp = CheckCode.find_by_counter_type("check_code")
		temp.update_attributes(:counter => temp.counter.next)
		temp.counter
	end

	def self.get_next_quality_action_number
		temp = CheckCode.find_by_counter_type("quality_next")
		temp.update_attributes(:counter => temp.counter.next)
		temp.counter
	end
end