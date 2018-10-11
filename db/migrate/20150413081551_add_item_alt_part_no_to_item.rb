class AddItemAltPartNoToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :item_alt_part_no, :string
  end
end
