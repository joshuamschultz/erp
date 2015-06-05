class AddShipmentProcessIdToSoShipment < ActiveRecord::Migration
  def change
    add_column :so_shipments, :shipment_process_id, :string
  end
end
