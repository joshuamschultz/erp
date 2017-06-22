class CreateCommodities < ActiveRecord::Migration
  def change
    create_table :commodities do |t|
      t.boolean :commodity_active
      t.string :commodity_identifier
      t.string :commodity_description
      t.text :commodity_notes

      t.timestamps
    end
  end
end
