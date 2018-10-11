class AddPayableIdToGlEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :gl_entries, :payable_id, :integer
  end
end
