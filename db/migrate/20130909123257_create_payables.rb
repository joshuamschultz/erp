class CreatePayables < ActiveRecord::Migration
  def change
    create_table :payables do |t|
      t.references :organization
      t.references :po_header
      t.integer :payable_to_id
      t.string :payable_identifier
      t.string :payable_description
      t.decimal :payable_cost, :precision => 15, :scale => 10, :default => 0
      t.decimal :payable_discount, :precision => 15, :scale => 10, :default => 0
      t.decimal :payable_total, :precision => 15, :scale => 10, :default => 0
      t.date :payable_invoice_date
      t.date :payable_due_date
      t.text :payable_notes
      t.string :payable_status
      t.boolean :payable_active
      t.integer :payable_created_id
      t.integer :payable_updated_id

      t.timestamps
    end
    add_index :payables, :organization_id
    add_index :payables, :po_header_id
  end
end
