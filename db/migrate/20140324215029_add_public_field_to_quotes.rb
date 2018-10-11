class AddPublicFieldToQuotes < ActiveRecord::Migration[5.0]
  	def change
  		add_column :quotes, :attachment_public, :boolean, :default => false
  		add_column :quote_lines, :item_name_sub, :string
  	end
end
