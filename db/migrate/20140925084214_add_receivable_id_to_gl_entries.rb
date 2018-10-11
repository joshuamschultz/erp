class AddReceivableIdToGlEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :gl_entries, :receivable_id, :integer
  end
end
