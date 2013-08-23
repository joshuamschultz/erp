class CreateSoHeaders < ActiveRecord::Migration
  def change
    create_table :so_headers do |t|
      t.references :organization
      t.string :so_identifier
      t.integer :so_bill_to_id
      t.integer :so_ship_to_id
      t.boolean :so_cofc
      t.boolean :so_squality
      t.decimal :so_total, :precision => 15, :scale => 5
      t.text :so_notes
      t.text :so_comments
      t.string :so_status
      t.integer :so_created_id
      t.integer :so_updated_id

      t.timestamps
    end
    add_index :so_headers, :organization_id
  end
end
