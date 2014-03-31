class CreateCustomerQualities < ActiveRecord::Migration
  def change
    create_table :customer_qualities do |t|
      t.string :quality_name
      t.string :quality_description
      t.text :quality_notes
      t.boolean :quality_active
      t.integer :quality_created_id
      t.integer :quality_updated_id
      t.boolean :quality_supplier_a
      t.boolean :quality_supplier_b
      t.boolean :quality_floor_plan
      t.boolean :quality_form
      t.boolean :quality_packaging
      t.boolean :quality_psw
      t.boolean :quality_control_plan
      t.boolean :quality_fmea
      t.boolean :quality_process_flow
      t.boolean :quality_gauge
      t.boolean :quality_study
      t.boolean :quality_dimensional_cofc
      t.boolean :quality_material_cofc

      t.timestamps
    end
  end
end
