class AddReceiptIdToCreditRegister < ActiveRecord::Migration[5.0]
  def change
    add_column :credit_registers, :receipt_id, :integer
  end
end
