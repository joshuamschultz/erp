class DropOwner < ActiveRecord::Migration[5.2]
  def change
    drop_table :owners
  end
end
