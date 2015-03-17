class AddLotCountToItemRevision < ActiveRecord::Migration
  def change
    add_column :item_revisions, :lot_count, :integer, :default => 0
  end
end
