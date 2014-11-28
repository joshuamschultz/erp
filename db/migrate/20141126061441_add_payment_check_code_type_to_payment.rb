class AddPaymentCheckCodeTypeToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :payment_check_code_type, :string
  end
end
