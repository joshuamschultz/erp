class CreateGroupOrganizations < ActiveRecord::Migration
  def change
    create_table :group_organizations do |t|
      t.references :organization
      t.references :group

      t.timestamps
    end
    add_index :group_organizations, :organization_id
    add_index :group_organizations, :group_id
  end
end
