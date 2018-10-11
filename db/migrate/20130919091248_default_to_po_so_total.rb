class DefaultToPoSoTotal < ActiveRecord::Migration[5.0]
  	def change
		change_column_default(:po_headers, :po_total, 0)
		change_column_default(:so_headers, :so_total, 0)
  	end
end
