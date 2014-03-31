class CreatePayableShipments < ActiveRecord::Migration
  def change
    create_table :payable_shipments do |t|
      t.references :payable
      t.references :po_line
      t.string :payable_shipment_identifier
      t.integer :payable_shipment_count, :default => 0
      t.decimal :payable_shipment_cost, :precision => 25, :scale => 10, :default => 0
      t.integer :payable_shipment_created_id
      t.integer :payable_shipment_updated_id

      t.timestamps
    end
    add_index :payable_shipments, :payable_id
    add_index :payable_shipments, :po_line_id
  end
end
