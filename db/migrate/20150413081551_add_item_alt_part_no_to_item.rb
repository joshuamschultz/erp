class AddItemAltPartNoToItem < ActiveRecord::Migration
  def change
    add_column :items, :item_alt_part_no, :string
  end
end
