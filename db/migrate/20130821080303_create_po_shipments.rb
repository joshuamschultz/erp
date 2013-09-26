class CreatePoShipments < ActiveRecord::Migration
  def change
    create_table :po_shipments do |t|
      t.references :payable
      t.references :po_line
      t.integer :shipped_item_count
      t.integer :shipped_item_cost
      t.integer :po_shipment_created_id
      t.integer :po_shipment_updated_id

      t.timestamps
    end
    add_index :po_shipments, :po_line_id
  end
end
