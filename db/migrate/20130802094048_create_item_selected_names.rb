class CreateItemSelectedNames < ActiveRecord::Migration
  def change
    create_table :item_selected_names do |t|
      t.references :item
      t.references :item_alt_name

      t.timestamps
    end
    add_index :item_selected_names, :item_id
    add_index :item_selected_names, :item_alt_name_id
  end
end
