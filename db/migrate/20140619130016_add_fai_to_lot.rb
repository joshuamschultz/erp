class AddFaiToLot < ActiveRecord::Migration
  def change
  	add_column :quality_lots, :fai, :Integer
  end
end
