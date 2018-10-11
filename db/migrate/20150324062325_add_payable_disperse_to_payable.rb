class AddPayableDisperseToPayable < ActiveRecord::Migration[5.0]
  def change
    add_column :payables, :payable_disperse, :string
  end
end
