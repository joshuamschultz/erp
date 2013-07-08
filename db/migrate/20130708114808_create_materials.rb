class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :material_short_name
      t.string :material_description
      t.text :material_notes
      t.integer :material_created_id
      t.integer :material_updated_id
      t.boolean :material_active

      t.timestamps
    end
  end
end
