class CreateTestItems < ActiveRecord::Migration
  def change
    create_table :test_items do |t|
      t.references :test_package
      t.string :item_name

      t.timestamps
    end
    add_index :test_items, :test_package_id
  end
end
