class ChangeFaiColumnInQualityLot < ActiveRecord::Migration[5.0]
	def change
  		change_column :quality_lots, :fai, :string
	end
end
