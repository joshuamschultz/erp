class AddReceiptIdToCreditRegister < ActiveRecord::Migration
  def change
    add_column :credit_registers, :receipt_id, :integer
  end
end
