class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.references :quality_lot
      t.decimal :part_size_length
      t.decimal :part_size_width
      t.decimal :part_size_height

      t.decimal :container_length
      t.decimal :container_width
      t.decimal :container_height

      t.decimal :pallet_length
      t.decimal :pallet_width
      t.decimal :pallet_height

      t.decimal :load_shipped_length
      t.decimal :load_shipped_width
      t.decimal :load_shipped_height
      
      t.decimal :part_weight
      t.decimal :dunnage_tare_Weight
      t.decimal :container_tare_weight
      t.decimal :pallet_tare_weight
      t.decimal :container_gross_inc_weight
      t.decimal :unit_load_gross
      t.integer :quantity_per_container
      t.integer :container_per_layer_pallet
      t.integer :layers_per_pallet
      t.integer :container_per_pallet
      t.text :package_comment

      t.string :part_content_type
      t.integer :part_file_size
      t.datetime :part_updated_at
      t.string :part_file_name

      t.string :container_content_type
      t.integer :container_file_size
      t.datetime :container_updated_at
      t.string :container_file_name

      t.string :dunnage_content_type
      t.integer :dunnage_file_size
      t.datetime :dunnage_updated_at
      t.string :dunnage_file_name

      t.string :unit_load_content_type
      t.integer :unit_load_file_size
      t.datetime :unit_load_updated_at
      t.string :unit_load_file_name

      t.timestamps
    end
  end
end
