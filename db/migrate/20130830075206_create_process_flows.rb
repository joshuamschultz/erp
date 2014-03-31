class CreateProcessFlows < ActiveRecord::Migration
  def change
    create_table :process_flows do |t|
      t.string :process_identifier
      t.string :process_name
      t.string :process_description
      t.text :process_notes
      t.boolean :process_active
      t.integer :process_created_id
      t.integer :process_updated_id

      t.timestamps
    end
  end
end
