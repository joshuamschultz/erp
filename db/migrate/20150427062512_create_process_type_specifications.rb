class CreateProcessTypeSpecifications < ActiveRecord::Migration
  def change
    create_table :process_type_specifications do |t|
      t.integer :process_type_id
      t.integer :specification_id

      t.timestamps
    end
  end
end
