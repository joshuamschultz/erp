class AddPayableAccountsIdToGlEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :gl_entries, :payable_account_id, :integer
  end
end
