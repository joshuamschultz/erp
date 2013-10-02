class CreatePoShipments < ActiveRecord::Migration
  def change
    create_table :po_shipments do |t|
      t.references :po_line
      t.integer :po_shipped_count, :default => 0
      t.decimal :po_shipped_cost, :decimal, :precision => 25, :scale => 10, :default => 0
      t.string :po_shipped_shelf
      t.string :po_shipped_unit
      t.integer :po_shipment_created_id
      t.integer :po_shipment_updated_id

      t.timestamps
    end
    add_index :po_shipments, :po_line_id
  end
end
