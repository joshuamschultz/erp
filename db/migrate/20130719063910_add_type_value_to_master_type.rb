class AddTypeValueToMasterType < ActiveRecord::Migration
  def change
  		add_column :master_types, :type_value, :string
  end
end
