class AddSupplierCodeToPackage < ActiveRecord::Migration
  def change
  	add_column :packages, :supplier_code, :string
  end
end
