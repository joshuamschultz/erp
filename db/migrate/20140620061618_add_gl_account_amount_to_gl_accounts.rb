class AddGlAccountAmountToGlAccounts < ActiveRecord::Migration
  def change
    add_column :gl_accounts, :gl_account_amount, :float, :default => 0.00
  end
end
