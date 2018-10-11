class AddAqlDefaultToLot < ActiveRecord::Migration[5.0]
  def change
  		change_column_default(:quality_lots, :lot_aql_no, 1)
  end
end
