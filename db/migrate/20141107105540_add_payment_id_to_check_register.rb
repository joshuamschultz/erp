class AddPaymentIdToCheckRegister < ActiveRecord::Migration[5.0]
  def change
    add_column :check_registers, :payment_id, :integer
  end
end
