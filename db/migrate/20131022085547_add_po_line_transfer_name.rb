class AddPoLineTransferName < ActiveRecord::Migration[5.0]
  def change
  		add_column :po_lines, :alt_name_transfer_id, :integer
  		add_index :po_lines, :alt_name_transfer_id
  end
end
