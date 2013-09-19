class CreatePayableLines < ActiveRecord::Migration
  def change
    create_table :payable_lines do |t|
      t.references :payable
      t.string :payable_line_identifier
      t.string :payable_line_description
      t.decimal :payable_line_cost, :precision => 15, :scale => 10, :default => 0
      t.text :payable_line_notes
      t.string :payable_line_status
      t.boolean :payable_line_active
      t.integer :payable_line_created_id
      t.integer :payable_line_updated_id

      t.timestamps
    end
    add_index :payable_lines, :payable_id
  end
end
