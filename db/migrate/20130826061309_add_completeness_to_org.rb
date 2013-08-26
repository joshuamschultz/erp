class AddCompletenessToOrg < ActiveRecord::Migration
  def change
  		add_column :organizations, :organization_complete, :boolean, :default => false
  end
end
