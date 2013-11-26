class AddSellToPoline < ActiveRecord::Migration
  def change
  		add_column :po_lines, :po_line_sell, :decimal, :precision => 25, :scale => 10, :default => 0
  end
end
