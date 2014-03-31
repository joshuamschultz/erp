class CreateSpecifications < ActiveRecord::Migration
  def change
    create_table :specifications do |t|
      t.boolean :specification_active
      t.integer :specification_created_id
      t.integer :specification_updated_id
      t.string :specification_identifier
      t.string :specification_description
      t.text :specification_notes

      t.timestamps
    end
  end
end
