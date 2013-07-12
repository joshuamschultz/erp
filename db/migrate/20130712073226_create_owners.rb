class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :owner_identifier
      t.string :owner_description
      t.integer :owner_commission_type_id
      t.decimal :owner_commission_amount
      t.integer :owner_created_id
      t.integer :owner_updated_id
      t.boolean :owner_active, :default => true

      t.timestamps
    end
  end
end
