class AddPoHeaderIdToSoLines < ActiveRecord::Migration
  def change
    add_column :so_lines, :po_header_id, :integer
  end
end
