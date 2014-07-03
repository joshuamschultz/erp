class ChangeFaiColumnInQualityLot < ActiveRecord::Migration
	def change
  		change_column :quality_lots, :fai, :string
	end
end
