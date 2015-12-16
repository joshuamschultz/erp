class AddQualityLotIdToPoLine < ActiveRecord::Migration
  def change
    add_column :po_lines, :quality_lot_id, :integer
  end
end
