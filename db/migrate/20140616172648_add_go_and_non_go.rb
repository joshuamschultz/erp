class AddGoAndNonGo < ActiveRecord::Migration[5.0]
	def change
    	add_column :item_part_dimensions, :go_non_go, :boolean, :default => false
    	add_column :item_part_dimensions, :dimension_string, :string
	end
end
