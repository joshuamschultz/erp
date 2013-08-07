# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.find_by_email('joshua@alliance.com')
	user = User.create(email: 'joshua@alliance.com', name: 'joshua', password: '12345678', password_confirmation: '12345678')
end

mastertypes = [
         ["All", "Sell * Quantity Shipped", "all", "commission_type", "true"],
         ["Profit", "[Sell - Cost] * Quantity Shipped", "profit", "commission_type", "true"],
         ["Fax", "", "fax" ,"customer_contact_type", "true"],
         ["Email", "", "email", "customer_contact_type", "true"],
         ["Customer", "", "customer", "organization_type", "true"],
         ["Vendor", "", "vendor", "organization_type", "true"],
         ["Support", "", "support", "organization_type", "true"],
         ["Regular", "", "regular", "po_type", "true"],
         ["Transer", "", "transer", "po_type", "true"],
         ["Direct", "", "direct", "po_type", "true"]
]

mastertypes.each do |master|
	unless MasterType.find_by_type_value(master[2])
		MasterType.create(:type_name => master[0], :type_description => master[1], :type_value => master[2], :type_category => master[3], :type_active => master[4])
	end
end
