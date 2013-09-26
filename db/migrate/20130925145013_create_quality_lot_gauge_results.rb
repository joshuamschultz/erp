class CreateQualityLotGaugeResults < ActiveRecord::Migration
  def change
    create_table :quality_lot_gauge_results do |t|
      t.references :quality_lot_gauge
      t.string :lot_gauge_result_appraiser
      t.decimal :lot_gauge_result_value

      t.timestamps
    end
    add_index :quality_lot_gauge_results, :quality_lot_gauge_id
  end
end
