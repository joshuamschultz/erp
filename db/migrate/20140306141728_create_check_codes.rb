class CreateCheckCodes < ActiveRecord::Migration
	def change
		create_table :check_codes do |t|
			t.string :counter
			t.string :counter_type
			t.timestamps
		end
	end
end