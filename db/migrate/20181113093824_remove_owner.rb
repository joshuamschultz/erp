class RemoveOwner < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_revisions, :owner_id
  end
end
