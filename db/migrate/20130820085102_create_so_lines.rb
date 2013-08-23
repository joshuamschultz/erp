class CreateSoLines < ActiveRecord::Migration
  def change
    create_table :so_lines do |t|
      t.references :so_header
      t.references :item
      t.references :item_revision
      t.references :item_alt_name
      t.references :organization
      t.decimal :so_line_cost, :precision => 15, :scale => 10
      t.decimal :so_line_price, :precision => 15, :scale => 10
      t.integer :so_line_quantity
      t.decimal :so_line_freight, :precision => 15, :scale => 10
      t.string :so_line_status
      t.text :so_line_notes
      t.boolean :so_line_active
      t.integer :so_line_created_id
      t.integer :so_line_updated_id

      t.timestamps
    end
    add_index :so_lines, :so_header_id
    add_index :so_lines, :organization_id
    add_index :so_lines, :item_id
    add_index :so_lines, :item_alt_name_id
    add_index :so_lines, :item_revision_id
  end
end
