class CreateSpecifications < ActiveRecord::Migration[5.0]
  def change
    create_table :specifications do |t|
      t.boolean :specification_active
      t.string :specification_identifier
      t.string :specification_description
      t.text :specification_notes

      t.timestamps
    end
  end
end
