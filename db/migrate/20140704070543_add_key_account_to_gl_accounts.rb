class AddKeyAccountToGlAccounts < ActiveRecord::Migration
  def change
    add_column :gl_accounts, :key_account, :boolean, :default => true 
  end
end
