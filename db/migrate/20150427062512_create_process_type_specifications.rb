class CreateProcessTypeSpecifications < ActiveRecord::Migration
  def change
    rename_column :process_type_specifications, :process_type, :process_type_id
  end
end
