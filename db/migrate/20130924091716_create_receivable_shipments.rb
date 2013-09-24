class CreateReceivableShipments < ActiveRecord::Migration
  def change
    create_table :receivable_shipments do |t|
      t.references :receivable
      t.references :so_line
      t.string :receivable_shipment_identifier
      t.integer :receivable_shipment_count, :default => 0
      t.decimal :receivable_shipment_cost, :precision => 25, :scale => 10, :default => 0
      t.integer :receivable_shipment_created_id
      t.integer :receivable_shipment_updated_id

      t.timestamps
    end
    add_index :receivable_shipments, :receivable_id
    add_index :receivable_shipments, :so_line_id
  end
end
