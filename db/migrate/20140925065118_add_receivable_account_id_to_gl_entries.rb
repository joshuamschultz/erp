class AddReceivableAccountIdToGlEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :gl_entries, :receivable_account_id, :integer
  end
end
