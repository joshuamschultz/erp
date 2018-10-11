class AddAutoFieldsToItemRevision < ActiveRecord::Migration[5.0]
  def change
  		add_column :item_revisions, :print_id, :integer
  		add_column :item_revisions, :material_id, :integer
  		add_column :item_revisions, :latest_revision, :boolean
  end
end
