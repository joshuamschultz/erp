class CreateOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :owners do |t|
      t.string :owner_identifier
      t.string :owner_description
      t.integer :owner_commission_type_id
      t.decimal :owner_commission_amount, :precision => 10, :scale => 10
      t.boolean :owner_active, :default => true

      t.timestamps
    end
  end
end
