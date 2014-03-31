class CreateQualityLotMaterials < ActiveRecord::Migration
  def change
    create_table :quality_lot_materials do |t|
      t.references :quality_lot
      t.references :material_element
      t.string :lot_element_low_range
      t.string :lot_element_high_range
      t.boolean :lot_material_tested
      t.string :lot_material_result
      t.text :lot_material_notes
      t.boolean :lot_material_active
      t.integer :lot_material_created_id
      t.integer :lot_material_updated_id

      t.timestamps
    end
    add_index :quality_lot_materials, :quality_lot_id
    add_index :quality_lot_materials, :material_element_id
  end
end
