class CreateSoShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :so_shipments do |t|
      t.references :so_line
      t.integer :so_shipped_count, :default => 0
      t.decimal :so_shipped_cost, :precision => 25, :scale => 10, :default => 0
      t.string :so_shipped_shelf
      t.string :so_shipped_unit
      t.string :so_shipped_status
      t.integer :so_shipment_created_id
      t.integer :so_shipment_updated_id      

      t.timestamps
    end
    add_index :so_shipments, :so_line_id
  end
end
