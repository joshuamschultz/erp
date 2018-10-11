class CreateCheckCodes < ActiveRecord::Migration[5.0]
	def change
		create_table :check_codes do |t|
			t.string :counter
			t.string :counter_type
			t.timestamps
		end
	end
end