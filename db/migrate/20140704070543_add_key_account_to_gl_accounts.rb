class AddKeyAccountToGlAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :gl_accounts, :key_account, :boolean, :default => true 
  end
end
