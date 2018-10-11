class AddShelfToLot < ActiveRecord::Migration[5.0]
  def change
  		add_column :quality_lots, :lot_shelf_idenifier, :string
  		add_column :quality_lots, :lot_shelf_unit, :integer
  		add_column :quality_lots, :lot_shelf_number, :integer
  end
end
