class AddAutoFieldsToItemRevision < ActiveRecord::Migration
  def change
  		add_column :item_revisions, :print_id, :integer
  		add_column :item_revisions, :material_id, :integer
  end
end
