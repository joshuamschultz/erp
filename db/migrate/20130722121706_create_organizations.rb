class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.references :user
      t.integer :organization_type_id
      t.references :territory
      t.references :customer_quality
      t.integer :customer_contact_type_id
      t.integer :customer_max_quality_id
      t.references :vendor_quality
      t.date :vendor_expiration_date
      t.string :organization_name
      t.string :organization_short_name
      t.string :organization_description
      t.text :organization_notes
      t.boolean :organization_active
      t.integer :organization_created_id
      t.integer :organization_updated_id

      t.timestamps
    end
    add_index :organizations, :user_id
    add_index :organizations, :territory_id
    add_index :organizations, :customer_quality_id
    add_index :organizations, :vendor_quality_id
  end
end
