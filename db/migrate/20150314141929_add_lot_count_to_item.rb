class AddLotCountToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :lot_count, :integer
  end
end
