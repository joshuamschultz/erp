class AddPayableAccountsIdToGlEntries < ActiveRecord::Migration
  def change
    add_column :gl_entries, :payable_account_id, :integer
  end
end
