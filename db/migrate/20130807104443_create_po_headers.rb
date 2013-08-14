class CreatePoHeaders < ActiveRecord::Migration
  def change
    create_table :po_headers do |t|
      t.integer :po_type_id
      t.references :organization
      t.string :po_identifier
      t.string :po_description
      t.decimal :po_total, :precision => 15, :scale => 5
      t.string :po_status
      t.text :po_notes
      t.boolean :po_active
      t.integer :po_created_id
      t.integer :po_updated_id

      t.timestamps
    end
    add_index :po_headers, :organization_id
  end
end
