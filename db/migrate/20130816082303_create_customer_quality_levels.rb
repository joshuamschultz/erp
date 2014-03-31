class CreateCustomerQualityLevels < ActiveRecord::Migration
  def change
    create_table :customer_quality_levels do |t|
      t.references :customer_quality
      t.references :master_type

      t.timestamps
    end
    add_index :customer_quality_levels, :customer_quality_id
    add_index :customer_quality_levels, :master_type_id
  end
end
