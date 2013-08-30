class CreateControlPlans < ActiveRecord::Migration
  def change
    create_table :control_plans do |t|
      t.string :plan_name
      t.string :plan_description
      t.text :plan_notes
      t.boolean :plan_active
      t.integer :plan_created_id
      t.integer :plan_updated_id

      t.timestamps
    end
  end
end
