class AddReceivableAccountIdToGlEntries < ActiveRecord::Migration
  def change
    add_column :gl_entries, :receivable_account_id, :integer
  end
end
