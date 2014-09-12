class AddPayableIdToGlEntries < ActiveRecord::Migration
  def change
    add_column :gl_entries, :payable_id, :integer
  end
end
