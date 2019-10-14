class RemoveAddressColumnsFromOrganization < ActiveRecord::Migration[5.2]
  def up
	remove_column :organizations, :organization_address_1
	remove_column :organizations, :organization_address_2
	remove_column :organizations, :organization_city
	remove_column :organizations, :organization_country
	remove_column :organizations, :organization_state
	remove_column :organizations, :organization_zipcode
  end

  def down
	add_column :organizations, :organization_address_1, :string
	add_column :organizations, :organization_address_2, :string
	add_column :organizations, :organization_city, :string
	add_column :organizations, :organization_country, :string
	add_column :organizations, :organization_state, :string
	add_column :organizations, :organization_zipcode, :string
  end
end
