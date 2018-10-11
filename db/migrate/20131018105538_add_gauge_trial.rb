class AddGaugeTrial < ActiveRecord::Migration[5.0]
  def change
  	add_column :quality_lot_gauge_results, :lot_gauge_result_trial, :integer
  	add_column :quality_lot_gauge_results, :lot_gauge_result_row, :integer
  end
end
