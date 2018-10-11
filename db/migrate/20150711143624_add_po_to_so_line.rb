class AddPoToSoLine < ActiveRecord::Migration[5.0]
  def change
    add_column :so_lines, :po, :string
  end
end
