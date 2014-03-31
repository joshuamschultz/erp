class ChangeReceivableFreight < ActiveRecord::Migration
  def change
	add_column :receivables, :receivable_freight, :decimal, :precision => 25, :scale => 10, :default => 0 
  end
end
