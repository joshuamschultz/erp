class AddCustomerpoToSoheader < ActiveRecord::Migration[5.0]
  def change
  	add_column :so_headers, :so_header_customer_po, :string
  end
end
