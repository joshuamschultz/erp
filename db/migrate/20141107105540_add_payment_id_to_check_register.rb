class AddPaymentIdToCheckRegister < ActiveRecord::Migration
  def change
    add_column :check_registers, :payment_id, :integer
  end
end
