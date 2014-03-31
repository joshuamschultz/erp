class CreateCheckCodes < ActiveRecord::Migration
	def change
		create_table :check_codes do |t|
			t.string :next_check_code
			t.timestamps
		end
	end
end