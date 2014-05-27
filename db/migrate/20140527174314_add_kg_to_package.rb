class AddKgToPackage < ActiveRecord::Migration
  def change
  	add_column :packages, :in_to_mm1, :decimal
  	add_column :packages, :in_to_mm2, :decimal
  	add_column :packages, :lbs_to_kg1, :decimal
  	add_column :packages, :lbs_to_kg2, :decimal
  end
end
