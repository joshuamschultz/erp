class AddLeadTime < ActiveRecord::Migration[5.0]
	def change
  		add_column :customer_quote_lines, :lead_time, :string
  	end
end
