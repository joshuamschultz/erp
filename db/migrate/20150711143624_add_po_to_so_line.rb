class AddPoToSoLine < ActiveRecord::Migration
  def change
    add_column :so_lines, :po, :string
  end
end
