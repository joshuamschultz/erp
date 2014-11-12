class AddPayableTypeToPayable < ActiveRecord::Migration
  def change
    add_column :payables, :payable_type, :string
  end
end
