class CreateVendorQualities < ActiveRecord::Migration[5.0]
  def change
    create_table :vendor_qualities do |t|
      t.string :quality_name
      t.string :quality_description
      t.text :quality_notes
      t.boolean :quality_active

      t.timestamps
    end
  end
end
