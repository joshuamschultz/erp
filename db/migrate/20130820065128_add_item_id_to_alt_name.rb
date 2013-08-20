class AddItemIdToAltName < ActiveRecord::Migration
  def change
  		change_table :item_alt_names do |t|
			t.references :item
		end
  end
end