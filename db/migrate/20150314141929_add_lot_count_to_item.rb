class AddLotCountToItem < ActiveRecord::Migration
  def change
    add_column :items, :lot_count, :integer
  end
end
