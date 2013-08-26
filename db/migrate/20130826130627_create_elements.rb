class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.string :element_name
      t.string :element_symbol
      t.text :element_notes
      t.integer :element_created_id
      t.integer :element_updated_id
      t.boolean :element_active

      t.timestamps
    end
  end
end
