class AddFinishQualityLot < ActiveRecord::Migration
	def change
    	add_column :quality_lots, :finished, :boolean, :default => false
    	add_column :quality_lots, :quantity_on_hand, :integer
    	add_column :so_shipments, :quality_lot_id, :integer, :default => 0
	end
end 
