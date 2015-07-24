class AddLotStatusToQualityLot < ActiveRecord::Migration
  def change
    add_column :quality_lots, :lot_status, :string
    add_column :quality_lots, :final_date, :datetime
  end
end
