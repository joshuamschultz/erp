class AddSubNameToCusQuote < ActiveRecord::Migration[5.0]
  def change
  	add_column :customer_quote_lines, :item_name_sub, :string 
  end
end
