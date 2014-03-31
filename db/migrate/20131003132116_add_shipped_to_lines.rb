class AddShippedToLines < ActiveRecord::Migration
  def change
  		add_column :so_lines, :so_line_shipped, :integer, :default => 0
  		add_column :po_lines, :po_line_shipped, :integer, :default => 0
  end
end
