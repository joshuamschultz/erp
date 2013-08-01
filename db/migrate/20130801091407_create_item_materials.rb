class CreateItemMaterials < ActiveRecord::Migration
  def change
    create_table :item_materials do |t|
      t.references :item
      t.references :material

      t.timestamps
    end
    add_index :item_materials, :item_id
    add_index :item_materials, :material_id
  end
end
