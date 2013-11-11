class CreateReceivableLines < ActiveRecord::Migration
  def change
    create_table :receivable_lines do |t|
      t.references :receivable
      t.string :receivable_line_identifier
      t.string :receivable_line_description
      t.decimal :receivable_line_cost, :precision => 25, :scale => 10, :default => 0
      t.text :receivable_line_notes
      t.string :receivable_line_status
      t.boolean :receivable_line_active
      t.integer :receivable_line_created_id
      t.integer :receivable_line_updated_id

      t.timestamps
    end
    add_index :receivable_lines, :receivable_id
  end
end
