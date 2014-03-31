class CreateDimensions < ActiveRecord::Migration
  def change
    create_table :dimensions do |t|      
      t.string :dimension_identifier
      t.string :dimension_description
      t.text :dimension_notes
      t.boolean :dimension_active
      t.integer :dimension_created_id
      t.integer :dimension_updated_id

      t.timestamps
    end    
  end
end
