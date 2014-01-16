class ChangePayableFreight < ActiveRecord::Migration
  def change
  		change_column :payables, :payable_freight, :decimal, :precision => 25, :scale => 10, :default => 0 
  end
end
