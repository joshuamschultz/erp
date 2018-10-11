class AddShipmentProcessIdToSoShipment < ActiveRecord::Migration[5.0]
  def change
    add_column :so_shipments, :shipment_process_id, :string
  end
end
