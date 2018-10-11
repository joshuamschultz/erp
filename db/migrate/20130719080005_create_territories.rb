class CreateTerritories < ActiveRecord::Migration[5.0]
  def change
    create_table :territories do |t|
      t.boolean :territory_active
      t.string :territory_identifier
      t.string :territory_description
      t.string :territory_zip

      t.timestamps
    end
  end
end
