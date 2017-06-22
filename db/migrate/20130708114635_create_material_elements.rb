class CreateMaterialElements < ActiveRecord::Migration
  def change
    create_table :material_elements, id: false do |t|
      t.references :material
      t.references :element
      t.string :element_symbol
      t.string :element_name
      t.string :element_low_range
      t.string :element_high_range
      t.boolean :element_active, :default => true

      t.timestamps
    end
    add_index :material_elements, :material_id
    add_index :material_elements, :element_id
  end
end
