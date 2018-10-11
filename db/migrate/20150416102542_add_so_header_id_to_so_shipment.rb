class AddSoHeaderIdToSoShipment < ActiveRecord::Migration[5.0]
  def change
    add_column :so_shipments, :so_header_id, :integer
  end
end
