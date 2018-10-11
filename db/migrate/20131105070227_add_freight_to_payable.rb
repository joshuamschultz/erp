class AddFreightToPayable < ActiveRecord::Migration[5.0]
  def change
  		add_column :payables, :payable_freight, :string
  end
end
