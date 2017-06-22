class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :material_short_name
      t.string :material_description
      t.text :material_notes
      t.boolean :material_active, :default => true

      t.timestamps
    end
  end
end
