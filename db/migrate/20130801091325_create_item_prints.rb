class CreateItemPrints < ActiveRecord::Migration
  def change
    create_table :item_prints do |t|
      t.references :item_revision
      t.references :print

      t.timestamps
    end
    add_index :item_prints, :item_revision_id
    add_index :item_prints, :print_id
  end
end
