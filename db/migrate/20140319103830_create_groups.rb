class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_name
      t.string :group_type

      t.timestamps
    end
  end
end
