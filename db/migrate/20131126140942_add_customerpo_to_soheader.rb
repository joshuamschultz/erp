class AddCustomerpoToSoheader < ActiveRecord::Migration
  def change
  	add_column :so_headers, :so_header_customer_po, :string
  end
end
