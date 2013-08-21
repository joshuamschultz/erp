class CreatePoShipments < ActiveRecord::Migration
  def change
    create_table :po_shipments do |t|
      t.references :po_line
      t.string :shipped_item_identifier
      t.integer :shipped_item_count
      t.string :shipped_item_description
      t.boolean :po_shipment_active
      t.integer :po_shipment_created_id
      t.integer :po_shipment_updated_id

      t.timestamps
    end
    add_index :po_shipments, :po_line_id
  end
end
