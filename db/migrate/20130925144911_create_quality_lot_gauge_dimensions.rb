class CreateQualityLotGaugeDimensions < ActiveRecord::Migration
  def change
    create_table :quality_lot_gauge_dimensions do |t|
      t.references :quality_lot_gauge
      t.references :item_part_dimension
      t.boolean :lot_gauge_dimension_active

      t.timestamps
    end
    add_index :quality_lot_gauge_dimensions, :quality_lot_gauge_id
    add_index :quality_lot_gauge_dimensions, :item_part_dimension_id
  end
end
