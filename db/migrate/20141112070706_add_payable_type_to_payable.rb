class AddPayableTypeToPayable < ActiveRecord::Migration[5.0]
  def change
    add_column :payables, :payable_type, :string
  end
end
