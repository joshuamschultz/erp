class AddGlEntryIdToPayableAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :payable_accounts, :gl_entry_id, :integer
  end
end
