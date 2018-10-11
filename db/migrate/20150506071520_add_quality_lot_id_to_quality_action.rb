class AddQualityLotIdToQualityAction < ActiveRecord::Migration[5.0]
  def change
    add_column :quality_actions, :quality_lot_id, :integer
  end
end
