class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :item_part_no
      t.integer :item_quantity_on_order
      t.integer :item_quantity_in_hand
      t.boolean :item_active
      t.integer :item_created_id
      t.integer :item_updated_id

      t.timestamps
    end
  end
end
