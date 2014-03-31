class CreateVendorQualities < ActiveRecord::Migration
  def change
    create_table :vendor_qualities do |t|
      t.string :quality_name
      t.string :quality_description
      t.text :quality_notes
      t.boolean :quality_active
      t.integer :quality_created_id
      t.integer :quality_updated_id
      
      t.timestamps
    end
  end
end
