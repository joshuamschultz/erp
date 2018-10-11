class AddLotPrintStatusToQualityLot < ActiveRecord::Migration[5.0]
  def change
    add_column :quality_lots, :lot_print_status, :string
  end
end
