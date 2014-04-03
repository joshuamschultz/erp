class CreateCapacityPlannings < ActiveRecord::Migration
  def change
    create_table :capacity_plannings do |t|
      t.string :capacity_plan_name
      t.string :capacity_plan_description
      t.text :capacity_plan_notes
      t.boolean :capacity_plan_active
      t.integer :capacity_plan_created_id
      t.integer :capacity_plan_updated_id

      t.timestamps
    end
  end
end
