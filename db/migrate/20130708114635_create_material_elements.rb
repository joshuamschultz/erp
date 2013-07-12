class CreateMaterialElements < ActiveRecord::Migration
  def change
    create_table :material_elements do |t|
      t.references :material
      t.string :element_symbol
      t.string :element_name
      t.string :element_low_range
      t.string :element_high_range
      t.boolean :element_active, :default => true
      t.integer :element_created_id
      t.integer :element_updated_id

      t.timestamps
    end
    add_index :material_elements, :material_id
  end
end
