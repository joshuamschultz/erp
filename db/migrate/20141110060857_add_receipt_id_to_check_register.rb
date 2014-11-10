class AddReceiptIdToCheckRegister < ActiveRecord::Migration
  def change
    add_column :check_registers, :receipt_id, :integer
  end
end
