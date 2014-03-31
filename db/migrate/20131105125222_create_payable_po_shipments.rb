class CreatePayablePoShipments < ActiveRecord::Migration
  def change
    create_table :payable_po_shipments do |t|
      t.references :po_shipment
      t.references :payable

      t.timestamps
    end
    add_index :payable_po_shipments, :po_shipment_id
    add_index :payable_po_shipments, :payable_id
  end
end
