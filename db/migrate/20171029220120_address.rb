class Address < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.integer :addressable_id
      t.string :addressable_type
      t.string :address_type
      t.string :address_title
      t.string :address_description
      t.text :address_address_1
      t.text :address_address_2
      t.string :address_city
      t.string :address_state
      t.string :address_country
      t.string :address_zipcode
      t.string :address_telephone
      t.string :address_fax
      t.string :address_email
      t.string :address_website
      t.text :address_notes
      t.boolean :address_active
      t.integer :address_created_id
      t.integer :address_updated_id

      t.timestamps
    end
  end
end
