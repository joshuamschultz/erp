class CreateItemLots < ActiveRecord::Migration[5.0]
  def change
    create_table :item_lots do |t|
      t.integer :quality_lot_id
      t.integer :item_id
      t.integer :item_lot_count

      t.timestamps
    end
  end
end
