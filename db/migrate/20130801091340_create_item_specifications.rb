class CreateItemSpecifications < ActiveRecord::Migration
  def change
    create_table :item_specifications do |t|
      t.references :item_revision
      t.references :specification

      t.timestamps
    end
    add_index :item_specifications, :item_revision_id
    add_index :item_specifications, :specification_id
  end
end
