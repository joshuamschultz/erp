class CreateMasterTypes < ActiveRecord::Migration
  def change
    create_table :master_types do |t|
      t.string :type_name
      t.string :type_description
      t.string :type_category
      t.boolean :type_active, :default => true

      t.timestamps
    end
  end
end
