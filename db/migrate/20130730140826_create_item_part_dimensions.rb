class CreateItemPartDimensions < ActiveRecord::Migration
  def change
    create_table :item_part_dimensions do |t|
      t.references :item
      t.string :item_part_letter
      t.string :item_part_type
      t.string :item_part_pos_tolerance
      t.string :item_part_neg_tolerance
      t.boolean :item_part_critical
      t.text :item_part_notes
      t.boolean :item_part_active
      t.integer :item_part_created_id
      t.integer :item_part_updated_id

      t.timestamps
    end
    add_index :item_part_dimensions, :item_id
  end
end
