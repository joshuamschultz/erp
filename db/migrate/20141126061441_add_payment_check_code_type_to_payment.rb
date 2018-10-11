class AddPaymentCheckCodeTypeToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :payment_check_code_type, :string
  end
end
