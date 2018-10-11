class AddCompletenessToOrg < ActiveRecord::Migration[5.0]
  def change
  		add_column :organizations, :organization_complete, :boolean, :default => false
  end
end
