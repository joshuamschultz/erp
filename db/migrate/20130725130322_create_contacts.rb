class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :contactable_id
      t.string :contactable_type
      t.string :contact_type
      t.string :contact_title
      t.string :contact_description
      t.text :contact_address_1
      t.text :contact_address_2
      t.string :contact_city
      t.string :contact_state
      t.string :contact_country
      t.string :contact_zipcode
      t.string :contact_telephone
      t.string :contact_fax
      t.string :contact_email
      t.string :contact_website
      t.text :contact_notes
      t.boolean :contact_active
      t.integer :contact_created_id
      t.integer :contact_updated_id

      t.timestamps
    end
  end
end
