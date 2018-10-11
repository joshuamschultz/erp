class AddTypeValueToMasterType < ActiveRecord::Migration[5.0]
  def change
  		add_column :master_types, :type_value, :string
  end
end
