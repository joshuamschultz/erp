class AddSoHeaderIdToSoShipment < ActiveRecord::Migration
  def change
    add_column :so_shipments, :so_header_id, :integer
  end
end
