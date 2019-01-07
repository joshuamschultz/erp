class UpateItemAlt < ActiveRecord::Migration[5.2]
  def up
    change_column :item_alt_names, :item_alt_active, :boolean, default: true
  end
  
  def down
    change_column :item_alt_names, :item_alt_active, :boolean, default: nil
  end

  def change 
    remove_column :item_alt_names, :item_alt_created_id
    remove_column :item_alt_names, :item_alt_updated_id
  end
end
