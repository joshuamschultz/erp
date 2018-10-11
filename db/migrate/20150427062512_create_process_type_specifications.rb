class CreateProcessTypeSpecifications < ActiveRecord::Migration[5.0]
  def change
    create_table "process_type_specifications", :force => true do |t|
      t.integer  "process_type_id"
      t.integer  "specification_id"
      t.timestamps
    end
  end
end
