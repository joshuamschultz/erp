class CreateQualityLotGauges < ActiveRecord::Migration
  def change
    create_table :quality_lot_gauges do |t|
      t.references :quality_lot
      t.string :lot_gauge_status
      t.text :lot_gauge_notes
      t.boolean :lot_gauge_active
      t.integer :lot_gauge_created_id
      t.integer :lot_gauge_updated_id

      t.timestamps
    end
    add_index :quality_lot_gauges, :quality_lot_id
  end
end
