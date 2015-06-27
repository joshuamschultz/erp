class AddProcessTypeIdToPoLine < ActiveRecord::Migration
  def change
    add_column :po_lines, :process_type_id, :integer
  end
end
