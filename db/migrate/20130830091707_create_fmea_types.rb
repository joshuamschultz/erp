class CreateFmeaTypes < ActiveRecord::Migration
  def change
    create_table :fmea_types do |t|
      t.string :fmea_name
      t.string :fmea_description
      t.text :fmea_notes
      t.boolean :fmea_active
      t.integer :fmea_created_id
      t.integer :fmea_updated_id

      t.timestamps
    end
  end
end
