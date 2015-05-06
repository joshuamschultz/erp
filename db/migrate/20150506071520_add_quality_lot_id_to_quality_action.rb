class AddQualityLotIdToQualityAction < ActiveRecord::Migration
  def change
    add_column :quality_actions, :quality_lot_id, :integer
  end
end
