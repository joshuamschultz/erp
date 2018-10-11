class AddItemIdToAltName < ActiveRecord::Migration[5.0]
  def change
  		change_table :item_alt_names do |t|
			t.references :item
		end
  end
end