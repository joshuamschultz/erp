class CreateQualityLotDimensions < ActiveRecord::Migration
  def change
    create_table :quality_lot_dimensions do |t|
      t.references :quality_lot
      t.references :item_part_dimension
      t.decimal :lot_dimension_value, :precision => 15, :scale => 10
      t.string :lot_dimension_status
      t.text :lot_dimension_notes
      t.boolean :lot_dimension_active
      t.integer :lot_dimension_created_id
      t.integer :lot_dimension_updated_id

      t.timestamps
    end
    add_index :quality_lot_dimensions, :quality_lot_id
    add_index :quality_lot_dimensions, :item_part_dimension_id
  end
end
