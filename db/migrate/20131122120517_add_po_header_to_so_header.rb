class AddPoHeaderToSoHeader < ActiveRecord::Migration[5.0]
	def change
		add_column :po_headers, :so_header_id, :integer
		add_index :po_headers, :so_header_id
	end
end