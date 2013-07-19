class CreateTerritories < ActiveRecord::Migration
  def change
    create_table :territories do |t|
      t.boolean :territory_active
      t.integer :territory_created_id
      t.integer :territory_updated_id
      t.string :territory_identifier
      t.string :territory_description
      t.string :territory_zip

      t.timestamps
    end
  end
end
