class AddDefaultValueToRevision < ActiveRecord::Migration[5.0]
  def change
  	  change_column_default(:item_revisions, :item_revision_name, 0)
  end
end
