class AddVendorToPayable < ActiveRecord::Migration
  def change
  		add_column :payables, :payable_invoice, :string
  end
end