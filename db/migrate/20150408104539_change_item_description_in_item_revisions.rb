class ChangeItemDescriptionInItemRevisions < ActiveRecord::Migration
  def up
  	   change_column :item_revisions, :item_description, :text
  end

  def down
  	   change_column :item_revisions, :item_description, :string
  end
end
