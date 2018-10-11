class AddFaiToLot < ActiveRecord::Migration[5.0]
  def change
  	add_column :quality_lots, :fai, :Integer
  end
end
