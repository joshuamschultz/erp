class CreateQualityLotGaugeResults < ActiveRecord::Migration
  def change
    create_table :quality_lot_gauge_results do |t|
      t.references :quality_lot_gauge
      t.references :item_part_dimension
      t.string :lot_gauge_result_appraiser
      t.decimal :lot_gauge_result_value, :precision => 15, :scale => 10, :default => 0
      t.string :lot_gauge_result_status

      t.timestamps
    end
    add_index :quality_lot_gauge_results, :quality_lot_gauge_id
    add_index :quality_lot_gauge_results, :item_part_dimension_id
  end
end
