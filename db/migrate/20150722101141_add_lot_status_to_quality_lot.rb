class AddLotStatusToQualityLot < ActiveRecord::Migration[5.0]
  def change
    add_column :quality_lots, :lot_status, :string
    add_column :quality_lots, :final_date, :datetime
  end
end
