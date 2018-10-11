class AddVendorToPayable < ActiveRecord::Migration[5.0]
  def change
  		add_column :payables, :payable_invoice, :string
  end
end