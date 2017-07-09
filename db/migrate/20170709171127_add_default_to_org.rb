class AddDefaultToOrg < ActiveRecord::Migration[5.0]
  def change
    change_column :organizations, :organization_active, :boolean, default: true
  end
end
