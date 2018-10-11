class AddQualityLotIdToPoLine < ActiveRecord::Migration[5.0]
  def change
    add_column :po_lines, :quality_lot_id, :integer
  end
end
