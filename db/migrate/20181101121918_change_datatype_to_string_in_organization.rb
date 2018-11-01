class ChangeDatatypeToStringInOrganization < ActiveRecord::Migration[5.2]
  def change
  	 change_column :organizations, :organization_address_1, :string
  	 change_column :organizations, :organization_address_2, :string
  end
end
