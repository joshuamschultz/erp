class CreateTestPackages < ActiveRecord::Migration
  def change
    create_table :test_packages do |t|
      t.string :name

      t.timestamps
    end
  end
end
