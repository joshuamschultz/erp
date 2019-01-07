class AddDefaultToItem < ActiveRecord::Migration[5.2]
  def up
    change_column :items, :item_active, :boolean, default: true
  end
  
  def down
    change_column :items, :item_active, :boolean, default: nil
  end
end
