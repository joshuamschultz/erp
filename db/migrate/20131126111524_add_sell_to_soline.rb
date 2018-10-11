class AddSellToSoline < ActiveRecord::Migration[5.0]
  def change
  	add_column :so_lines, :so_line_sell, :decimal, :precision => 25, :scale => 10, :default => 0
  end
end
