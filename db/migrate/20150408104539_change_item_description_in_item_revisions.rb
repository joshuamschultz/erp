class ChangeItemDescriptionInItemRevisions < ActiveRecord::Migration[5.0]
  def up
  	   change_column :item_revisions, :item_description, :text
  end

  def down
  	   change_column :item_revisions, :item_description, :string
  end
end
