class CreatePoLines < ActiveRecord::Migration
  def change
    create_table :po_lines do |t|
      t.references :po_header
      t.references :organization
      t.references :so_line
      t.references :vendor_quality
      t.references :customer_quality
      t.references :item
      t.references :item_revision
      t.references :item_selected_name
      t.references :item_alt_name
      t.string :po_line_customer_po
      t.decimal :po_line_cost, :precision => 15, :scale => 10
      t.integer :po_line_quantity
      t.decimal :po_line_total, :precision => 15, :scale => 10
      t.string :po_line_status
      t.text :po_line_notes
      t.boolean :po_line_active
      t.integer :po_line_created_id
      t.integer :po_line_updated_id

      t.timestamps
    end
    add_index :po_lines, :po_header_id
    add_index :po_lines, :organization_id
    add_index :po_lines, :so_line_id
    add_index :po_lines, :vendor_quality_id
    add_index :po_lines, :customer_quality_id
    add_index :po_lines, :item_id
    add_index :po_lines, :item_revision_id
  end
end
