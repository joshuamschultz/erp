class AddCompletenessToItemRevision < ActiveRecord::Migration[5.0]
  def change
  		add_column :item_revisions, :item_revision_complete, :boolean, :default => false
  end
end
