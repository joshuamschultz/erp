class AddQualityLotIdToPoShipments < ActiveRecord::Migration
  def change
    add_column :po_shipments, :quality_lot_id, :integer
  end
end
