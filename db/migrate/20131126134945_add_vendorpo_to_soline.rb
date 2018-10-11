class AddVendorpoToSoline < ActiveRecord::Migration[5.0]
  def change
  	add_column :so_lines, :so_line_vendor_po, :string
  end
end
