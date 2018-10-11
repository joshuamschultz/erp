class AddReceiptIdToCheckRegister < ActiveRecord::Migration[5.0]
  def change
    add_column :check_registers, :receipt_id, :integer
  end
end
