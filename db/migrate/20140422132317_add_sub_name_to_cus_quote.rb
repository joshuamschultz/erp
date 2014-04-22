class AddSubNameToCusQuote < ActiveRecord::Migration
  def change
  	add_column :customer_quote_lines, :item_name_sub, :string 
  end
end
