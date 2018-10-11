class AddQualityLotIdToPoShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :po_shipments, :quality_lot_id, :integer
  end
end
