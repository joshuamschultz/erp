class AddLotUnitLotSelfToQualityLot < ActiveRecord::Migration[5.0]
  def change
    add_column :quality_lots, :lot_unit, :string
    add_column :quality_lots, :lot_self, :string
  end
end
