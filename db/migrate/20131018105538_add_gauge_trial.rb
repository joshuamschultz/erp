class AddGaugeTrial < ActiveRecord::Migration
  def change
  	add_column :quality_lot_gauge_results, :lot_gauge_result_trial, :integer
  end
end
