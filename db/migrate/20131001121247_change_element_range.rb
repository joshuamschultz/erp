class ChangeElementRange < ActiveRecord::Migration
  def change
  		change_column :quality_lot_materials, :lot_element_low_range, :decimal, :precision => 25, :scale => 10, :default => 0
  		change_column :quality_lot_materials, :lot_element_high_range, :decimal, :precision => 25, :scale => 10, :default => 0

  		change_column :material_elements, :element_low_range, :decimal, :precision => 25, :scale => 10, :default => 0
  		change_column :material_elements, :element_high_range, :decimal, :precision => 25, :scale => 10, :default => 0
  end
end
