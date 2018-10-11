class AddProcessTypeIdToPoLine < ActiveRecord::Migration[5.0]
  def change
    add_column :po_lines, :process_type_id, :integer
  end
end
