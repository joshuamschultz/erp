class RemoveItemUpdatedColumnFromItem < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :item_created_id
    remove_column :items, :item_updated_id
  end
end
