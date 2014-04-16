class AddLeadTime < ActiveRecord::Migration
	def change
  		add_column :customer_quote_lines, :lead_time, :string
  	end
end
