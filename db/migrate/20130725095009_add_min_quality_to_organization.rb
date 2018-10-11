class AddMinQualityToOrganization < ActiveRecord::Migration[5.0]
  def change
  		add_column :organizations, :customer_min_quality_id, :integer
  end
end
