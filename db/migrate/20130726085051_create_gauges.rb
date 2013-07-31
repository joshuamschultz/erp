class CreateGauges < ActiveRecord::Migration
  def change
    create_table :gauges do |t|
      t.references :organization
      t.string :gauge_tool_name
      t.string :gauge_tool_category
      t.string :gauge_tool_no
      t.date :gage_caliberation_last_at
      t.date :gage_caliberation_due_at
      t.integer :gage_caliberaion_period
      t.boolean :gauge_active
      t.integer :gauge_created_id
      t.integer :gauge_updated_id

      t.timestamps
    end
    add_index :gauges, :organization_id
  end
end
