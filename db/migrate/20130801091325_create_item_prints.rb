class CreateItemPrints < ActiveRecord::Migration
  def change
    create_table :item_prints do |t|
      t.references :item
      t.references :print

      t.timestamps
    end
    add_index :item_prints, :item_id
    add_index :item_prints, :print_id
  end
end
