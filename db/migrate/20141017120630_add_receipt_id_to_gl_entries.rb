class AddReceiptIdToGlEntries < ActiveRecord::Migration
  def change
    add_column :gl_entries, :receipt_id, :integer
  end
end
