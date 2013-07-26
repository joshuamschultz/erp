class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :owner
      t.string :item_part_no
      t.string :item_name
      t.string :item_description
      t.text :item_notes
      t.string :item_revision
      t.date :item_revision_date
      t.string :item_tooling
      t.decimal :item_cost
      t.integer :item_quantity_on_order
      t.integer :item_quantity_in_hand
      t.boolean :item_active
      t.integer :item_created_id
      t.integer :item_updated_id

      t.timestamps
    end
    add_index :items, :owner_id
  end
end
