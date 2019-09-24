class RemoveColumnsContacts < ActiveRecord::Migration[5.2]
  def up
	remove_column :contacts, :contact_address_1
	remove_column :contacts, :contact_address_2
	remove_column :contacts, :contact_city
	remove_column :contacts, :contact_country
	remove_column :contacts, :contact_state
	remove_column :contacts, :contact_zipcode
  end

  def down
	add_column :contacts, :contact_address_1, :string
	add_column :contacts, :contact_address_2, :string
	add_column :contacts, :contact_city, :string
	add_column :contacts, :contact_country, :string
	add_column :contacts, :contact_state, :string
	add_column :contacts, :contact_zipcode, :string
  end

end
