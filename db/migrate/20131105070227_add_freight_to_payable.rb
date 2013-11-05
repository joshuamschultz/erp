class AddFreightToPayable < ActiveRecord::Migration
  def change
  		add_column :payables, :payable_freight, :string
  end
end
