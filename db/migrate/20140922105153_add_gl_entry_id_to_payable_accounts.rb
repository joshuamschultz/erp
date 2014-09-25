class AddGlEntryIdToPayableAccounts < ActiveRecord::Migration
  def change
    add_column :payable_accounts, :gl_entry_id, :integer
  end
end
