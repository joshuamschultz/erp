class CreateReceivables < ActiveRecord::Migration
  def change
    create_table :receivables do |t|
      t.references :organization
      t.references :so_header
      t.string :receivable_identifier
      t.string :receivable_description
      t.decimal :receivable_cost, :precision => 25, :scale => 10, :default => 0
      t.decimal :receivable_discount, :precision => 25, :scale => 10, :default => 0
      t.decimal :receivable_total, :precision => 25, :scale => 10, :default => 0
      t.text :receivable_notes
      t.string :receivable_status
      t.boolean :receivable_active
      t.integer :receivable_created_id
      t.integer :receivable_updated_id

      t.timestamps
    end
    add_index :receivables, :organization_id
    add_index :receivables, :so_header_id
  end
end
