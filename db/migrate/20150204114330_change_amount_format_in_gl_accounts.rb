class ChangeAmountFormatInGlAccounts < ActiveRecord::Migration
  def up
  change_column :gl_accounts, :gl_account_amount, :decimal, :precision => 15, :scale => 10, :default => 0
  end

  def down
  end
end
