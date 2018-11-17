class RemoveForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_index :item_revisions, name: :index_item_revisions_on_owner_id
  end
end
