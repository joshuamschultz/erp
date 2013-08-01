class CreateItemSpecifications < ActiveRecord::Migration
  def change
    create_table :item_specifications do |t|
      t.references :item
      t.references :specification

      t.timestamps
    end
    add_index :item_specifications, :item_id
    add_index :item_specifications, :specification_id
  end
end
