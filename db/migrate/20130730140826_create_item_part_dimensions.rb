class CreateItemPartDimensions < ActiveRecord::Migration
  def change
    create_table :item_part_dimensions do |t|
      t.references :item_revision
      t.references :dimension
      t.references :gauge
      t.string :item_part_letter
      t.string :item_part_dimension
      t.string :item_part_pos_tolerance
      t.string :item_part_neg_tolerance
      t.boolean :item_part_critical
      t.text :item_part_notes
      t.boolean :item_part_active
      t.integer :item_part_created_id
      t.integer :item_part_updated_id

      t.timestamps
    end
    add_index :item_part_dimensions, :item_revision_id
    add_index :item_part_dimensions, :dimension_id
    add_index :item_part_dimensions, :gauge_id
  end
end
