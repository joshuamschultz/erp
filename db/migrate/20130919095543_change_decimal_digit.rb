class ChangeDecimalDigit < ActiveRecord::Migration
  def change
  	change_column :item_revisions, :item_tooling, :decimal, :precision => 25, :scale => 10, :default => 0  	
  	change_column :item_revisions, :item_cost, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :owners, :owner_commission_amount, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :payables, :payable_cost, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :payables, :payable_discount, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :payables, :payable_total, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :payable_lines, :payable_line_cost, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :quality_lot_dimensions, :lot_dimension_value, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :so_headers, :so_total, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :so_lines, :so_line_cost, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :so_lines, :so_line_price, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :so_lines, :so_line_freight, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :po_headers, :po_total, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :po_lines, :po_line_cost, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :po_lines, :po_line_total, :decimal, :precision => 25, :scale => 10, :default => 0
  	change_column :quality_lot_capabilities, :lot_dimension_value, :decimal, :precision => 25, :scale => 10, :default => 0
  end
end
