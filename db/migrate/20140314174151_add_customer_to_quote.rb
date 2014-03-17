class AddCustomerToQuote < ActiveRecord::Migration
  def change
  	add_column :quotes, :customer_id, :integer 
  end
end
