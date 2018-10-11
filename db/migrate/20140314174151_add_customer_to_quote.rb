class AddCustomerToQuote < ActiveRecord::Migration[5.0]
  def change
  	add_column :quotes, :customer_id, :integer 
  end
end
