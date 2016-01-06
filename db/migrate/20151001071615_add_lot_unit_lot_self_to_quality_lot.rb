class AddLotUnitLotSelfToQualityLot < ActiveRecord::Migration
  def change
    add_column :quality_lots, :lot_unit, :string
    add_column :quality_lots, :lot_self, :string
  end
end
