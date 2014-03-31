class CreateOrganizationProcesses < ActiveRecord::Migration
  def change
    create_table :organization_processes do |t|
      t.references :organization
      t.references :process_type
      t.boolean :org_process_active
      t.integer :org_process_created_id
      t.integer :org_process_updated_id

      t.timestamps
    end
    add_index :organization_processes, :organization_id
    add_index :organization_processes, :process_type_id
  end
end
