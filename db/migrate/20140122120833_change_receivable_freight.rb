class ChangeReceivableFreight < ActiveRecord::Migration[5.0]
  def change
	add_column :receivables, :receivable_freight, :decimal, :precision => 25, :scale => 10, :default => 0 
  end
end
