class AddReceiptIdToGlEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :gl_entries, :receipt_id, :integer
  end
end
