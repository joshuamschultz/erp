class AddMinQualityToOrganization < ActiveRecord::Migration
  def change
  		add_column :organizations, :customer_min_quality_id, :integer
  end
end
