class AddLotPrintStatusToQualityLot < ActiveRecord::Migration
  def change
    add_column :quality_lots, :lot_print_status, :string
  end
end
