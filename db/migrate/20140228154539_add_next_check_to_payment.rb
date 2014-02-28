class AddNextCheckToPayment < ActiveRecord::Migration
	def change
		add_column :payments, :next_check_code , :string
	end
end