class AddRunRateToQualityLot < ActiveRecord::Migration
  def change
  	add_column :quality_lots, :run_at_rate_id, :integer
  end
end
