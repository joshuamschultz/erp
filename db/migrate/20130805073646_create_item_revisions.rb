class CreateItemRevisions < ActiveRecord::Migration
  def change
    create_table :item_revisions do |t|
      t.string :item_revision_name
      t.date :item_revision_date
      t.references :item
      t.references :owner
      t.references :organization
      t.references :vendor_quality
      t.references :customer_quality
      t.string :item_name
      t.string :item_description
      t.text :item_notes
      t.decimal :item_tooling, :precision => 10, :scale => 2
      t.decimal :item_cost, :scale => 2
      t.integer :item_revision_created_id
      t.integer :item_revision_updated_id

      t.timestamps
    end
    add_index :item_revisions, :item_id
    add_index :item_revisions, :owner_id
    add_index :item_revisions, :organization_id
    add_index :item_revisions, :vendor_quality_id
    add_index :item_revisions, :customer_quality_id
  end
end
