class AddGlEntryIdToReceivableAccounts < ActiveRecord::Migration
  def change
    add_column :receivable_accounts, :gl_entry_id, :integer
  end
end
