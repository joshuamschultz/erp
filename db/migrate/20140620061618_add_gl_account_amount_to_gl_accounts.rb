class AddGlAccountAmountToGlAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :gl_accounts, :gl_account_amount, :float, :default => 0.00
  end
end
