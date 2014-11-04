class AddDefaultValueToRevision < ActiveRecord::Migration
  def change
  	  change_column_default(:item_revisions, :item_revision_name, 0)
  end
end
