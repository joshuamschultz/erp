class CreateItemAltNames < ActiveRecord::Migration
  def change
    create_table :item_alt_names do |t|
      t.references :item
      t.string :item_alt_identifier
      t.string :item_alt_description
      t.text :item_alt_notes
      t.boolean :item_alt_active
      t.integer :item_alt_created_id
      t.integer :item_alt_updated_id

      t.timestamps
    end
    add_index :item_alt_names, :item_id
  end
end
