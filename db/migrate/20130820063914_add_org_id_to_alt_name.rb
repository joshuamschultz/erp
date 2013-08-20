class AddOrgIdToAltName < ActiveRecord::Migration
	def change
		change_table :item_alt_names do |t|
			t.references :organization
		end
	end
end
