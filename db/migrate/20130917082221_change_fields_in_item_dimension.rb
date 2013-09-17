class ChangeFieldsInItemDimension < ActiveRecord::Migration
  def change
	change_column :item_part_dimensions, :item_part_dimension, :decimal, :precision => 15, :scale => 10, :default => 0
	change_column :item_part_dimensions, :item_part_pos_tolerance, :decimal, :precision => 15, :scale => 10, :default => 0
	change_column :item_part_dimensions, :item_part_neg_tolerance, :decimal, :precision => 15, :scale => 10, :default => 0
	change_column_default(:quality_lot_dimensions, :lot_dimension_value, 0)
  end
end
