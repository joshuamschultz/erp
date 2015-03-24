class AddPayableDisperseToPayable < ActiveRecord::Migration
  def change
    add_column :payables, :payable_disperse, :string
  end
end
