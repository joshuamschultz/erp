class AddLotCountToItemRevision < ActiveRecord::Migration[5.0]
  def change
    add_column :item_revisions, :lot_count, :integer, :default => 0
  end
end
