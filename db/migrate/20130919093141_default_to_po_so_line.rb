class DefaultToPoSoLine < ActiveRecord::Migration[5.0]
  def change
  		change_column_default(:po_lines, :po_line_cost, 0)
  		change_column_default(:po_lines, :po_line_quantity, 0)
  		change_column_default(:po_lines, :po_line_total, 0)
		change_column_default(:so_lines, :so_line_cost, 0)
		change_column_default(:so_lines, :so_line_price, 0)
		change_column_default(:so_lines, :so_line_quantity, 0)
  end
end
