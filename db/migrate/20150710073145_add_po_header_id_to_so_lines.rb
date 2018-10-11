class AddPoHeaderIdToSoLines < ActiveRecord::Migration[5.0]
  def change
    add_column :so_lines, :po_header_id, :integer
  end
end
