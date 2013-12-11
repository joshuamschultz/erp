class CreateReceivableSoShipments < ActiveRecord::Migration
  def change
    create_table :receivable_so_shipments do |t|
      t.references :so_shipment
      t.references :receivable

      t.timestamps
    end
    add_index :receivable_so_shipments, :so_shipment_id
    add_index :receivable_so_shipments, :receivable_id
  end
end
