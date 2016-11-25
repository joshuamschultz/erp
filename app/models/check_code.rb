class CheckCode < ActiveRecord::Base	 

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
	def check_code_params
		params.require(:check_code).permit(:counter, :counter_type)
	end
end