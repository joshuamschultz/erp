class AddSupplierCodeToPackage < ActiveRecord::Migration[5.0]
  def change
  	add_column :packages, :supplier_code, :string
  end
end
