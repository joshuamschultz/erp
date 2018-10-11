class AddParentIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :parent_id, :integer
  end
end
