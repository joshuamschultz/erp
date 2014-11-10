class AddCheckRegisterIdToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :check_register_id, :integer
  end
end
