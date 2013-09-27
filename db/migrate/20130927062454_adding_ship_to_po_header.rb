class AddingShipToPoHeader < ActiveRecord::Migration
	def change
		add_column :po_headers, :customer_id, :integer
		add_column :po_headers, :po_bill_to_id, :integer
		add_column :po_headers, :po_ship_to_id, :integer
		add_column :po_headers, :cusotmer_po, :string
	end
end
