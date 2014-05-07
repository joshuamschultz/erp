class AddSellCostItemRevision < ActiveRecord::Migration
	def change
  		add_column :item_revisions, :item_sell, :decimal, :precision => 15, :scale => 10
  	end
end