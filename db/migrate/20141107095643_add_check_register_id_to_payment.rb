class AddCheckRegisterIdToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :check_register_id, :integer
  end
end
