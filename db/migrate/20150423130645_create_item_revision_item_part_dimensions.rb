class CreateItemRevisionItemPartDimensions < ActiveRecord::Migration
  def change
    create_table :item_revision_item_part_dimensions do |t|
      t.integer :item_revision_id
      t.integer :item_part_dimension_id

      t.timestamps
    end
  end
end
