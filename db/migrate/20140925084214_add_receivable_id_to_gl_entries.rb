class AddReceivableIdToGlEntries < ActiveRecord::Migration
  def change
    add_column :gl_entries, :receivable_id, :integer
  end
end
