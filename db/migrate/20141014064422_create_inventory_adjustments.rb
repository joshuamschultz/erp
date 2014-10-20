class CreateInventoryAdjustments < ActiveRecord::Migration
  def change
    create_table :inventory_adjustments do |t|
      t.integer :inventory_adjustment_quantity
      t.string :inventory_adjustment_description
      t.integer :item_id
      t.integer :item_alt_name_id
      t.integer :quality_lot_id

      t.timestamps
    end
  end
end
