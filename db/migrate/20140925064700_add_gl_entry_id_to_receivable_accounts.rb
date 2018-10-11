class AddGlEntryIdToReceivableAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :receivable_accounts, :gl_entry_id, :integer
  end
end
