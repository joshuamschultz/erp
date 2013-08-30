class CreateQualityLots < ActiveRecord::Migration
  def change
    create_table :quality_lots do |t|
      t.references :po_header
      t.references :po_line
      t.references :item_revision
      t.references :process_flow
      t.references :control_plan
      t.references :fmea_type
      t.string :lot_control_no
      t.integer :lot_quantity
      t.integer :inspection_level_id
      t.integer :inspection_method_id
      t.integer :inspection_type_id
      t.integer :lot_inspector_id
      t.datetime :lot_finalized_at
      t.string :lot_aql_no
      t.text :lot_notes
      t.boolean :lot_active
      t.integer :lot_created_id
      t.integer :lot_updated_id

      t.timestamps
    end
    add_index :quality_lots, :po_header_id
    add_index :quality_lots, :po_line_id
    add_index :quality_lots, :item_revision_id
  end
end
