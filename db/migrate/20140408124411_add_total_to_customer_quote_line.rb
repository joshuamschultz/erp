class AddTotalToCustomerQuoteLine < ActiveRecord::Migration[5.0]
  def change
  	add_column :customer_quote_lines, :customer_quote_line_total, :decimal, :precision => 25, :scale => 10, :default => 0  	 
  end
end