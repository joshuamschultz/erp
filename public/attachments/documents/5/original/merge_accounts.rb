detailed_data = {}
ids = [[5,57],[83,84],[26,71]] #ids to be updated
Organization.where(id: ids.flatten).each do |org|
	data = {}
	data[:account_id] = org.account.try(:id)
	data[:alt_customer_relationships] = data[:account_id] ? CustomerRelationship.where(account_id: data[:account_id]).collect(&:id) : []
	data[:alt_supplier_relationships] = data[:account_id] ? SupplierRelationship.where(account_id: data[:account_id]).collect(&:id) : []
	data[:customer_relationships] = org.customer_relationships.collect(&:id)
	data[:customer_relationships].each do |cust_relation_id|
		data[:vmi] = {}
		data[:org_items] = {}
		data[:vmi][cust_relation_id] = CustomerRelationship.where(id: cust_relation_id).first.vmi_programs.try(:pluck, :id)
		data[:org_items][cust_relation_id] = CustomerRelationship.where(id: cust_relation_id).first.organization_items.try(:pluck, :id)
	end
	data[:supplier_relationships] = org.supplier_relationships.collect(&:id)
	data[:organization_items] = org.organization_items.collect(&:id)
	data[:contacts] = org.contacts.collect(&:id)
	data[:proposals] = org.proposals.collect(&:id)
	data[:users] = org.users.collect(&:id)
	if org.customer_profile
		data[:customer_profile] ={updated_at: org.customer_profile.updated_at, id: org.customer_profile.id}
	end
	if org.supplier_profile
		data[:supplier_profile] ={updated_at: org.supplier_profile.updated_at, id: org.supplier_profile.id}
	end
	org.attributes.each do |key, value|
		data[key] = value
	end
	detailed_data[org.id.to_s] =  data
end

def update_relation(object, association, relation, remove=false, ids=[])
	if relation == 'has_many'
		association.singularize.camelcase.constantize.where(id: ids).update_all("#{object.class.name.downcase}_id": (remove ? nil : object.id))
	elsif relation == 'belongs_to'
		association["#{object.class.name.downcase}_id"]  =  (remove ? nil : object.id)
		association.save!
	end
end

def update_notes(most, least)
	if most.notes.present?
		most.notes += ' ' + least.notes.to_s
	else
		most.notes = least.notes.to_s
	end
	most.save
end


account_to_create = []
ids.each do |arr_ids|
	if detailed_data[arr_ids[0].to_s]['updated_at'] > detailed_data[arr_ids[1].to_s]['updated_at']
		most_updated_org = Organization.find arr_ids[0].to_i
		least_updated_org = Organization.find arr_ids[1].to_i
		most_updated_account_id = detailed_data[arr_ids[0].to_s][:account_id]
		least_updated_account_id = detailed_data[arr_ids[1].to_s][:account_id]
	else
		most_updated_org = Organization.find arr_ids[1].to_i
		least_updated_org = Organization.find arr_ids[0].to_i
		most_updated_account_id = detailed_data[arr_ids[1].to_s][:account_id]
		least_updated_account_id = detailed_data[arr_ids[0].to_s][:account_id]

	end
	puts 'org loaded'
	if detailed_data[arr_ids[1].to_s].try(:[], :customer_profile).try(:[],:updated_at) and detailed_data[arr_ids[0].to_s].try(:[], :customer_profile).try(:[],:updated_at)
		if detailed_data[arr_ids[0].to_s].try(:[], :customer_profile).try(:[],:updated_at).to_i > detailed_data[arr_ids[1].to_s].try(:[], :customer_profile).try(:[],:updated_at).to_i
			most_updated_customer_profile = CustomerProfile.find detailed_data[arr_ids[0].to_s][:customer_profile][:id]
			least_updated_customer_profile = CustomerProfile.find detailed_data[arr_ids[1].to_s][:customer_profile][:id]

		else
			most_updated_customer_profile = CustomerProfile.find detailed_data[arr_ids[1].to_s][:customer_profile][:id]
			least_updated_customer_profile = CustomerProfile.find  detailed_data[arr_ids[0].to_s][:customer_profile][:id]
		end
		puts 'Customer profiles loaded'
		update_notes(most_updated_customer_profile, least_updated_customer_profile)
		puts 'notes updated'
		update_relation(most_updated_org, most_updated_customer_profile, 'belongs_to')
		puts 'customer relations updated'
	end
	if detailed_data[arr_ids[0].to_s].try(:[], :supplier_profile).try(:[],:updated_at) and detailed_data[arr_ids[1].to_s].try(:[], :supplier_profile).try(:[],:updated_at)
		if detailed_data[arr_ids[0].to_s].try(:[], :supplier_profile).try(:[],:updated_at).to_i > detailed_data[arr_ids[1].to_s].try(:[], :supplier_profile).try(:[],:updated_at).to_i
			most_updated_supplier_profile = SupplierProfile.find detailed_data[arr_ids[0].to_s][:supplier_profile][:id]
			least_updated_supplier_profile = SupplierProfile.find detailed_data[arr_ids[1].to_s][:supplier_profile][:id]

		else
			most_updated_supplier_profile = SupplierProfile.find detailed_data[arr_ids[1].to_s][:supplier_profile][:id]
			least_updated_supplier_profile = SupplierProfile.find  detailed_data[arr_ids[0].to_s][:supplier_profile][:id]
		end
		puts 'Supplier profiles loaded'
		update_notes(most_updated_supplier_profile, least_updated_supplier_profile)
		puts 'supplier notes updated'
		update_relation(most_updated_org, most_updated_supplier_profile, 'belongs_to')
		puts 'supplier relations updated'
	end
	['customer_relationships', 'users', 'supplier_relationships', 'contacts', 'organization_items', 'proposals'].each do |attrs|
		_ids = detailed_data[least_updated_org.id.to_s][attrs.to_sym]
		if attrs == 'customer_relationships' || attrs == 'supplier_relationships'
			relation = attrs.singularize.camelcase.constantize
			account_ids = relation.where(id: _ids).collect(&:account_id)
			accounts_relations = relation.where(account_id: account_ids, organization_id: most_updated_org.id).collect(&:account_id)
			_ids = relation.where('account_id not in (?) and id in (?)', accounts_relations, _ids).collect(&:id)
			if attrs == 'customer_relationships'
				relation.where(account_id: accounts_relations, organization_id: least_updated_org.id).each do |cust_rel|
					merge_into = relation.where(account_id: cust_rel.account_id, organization_id: most_updated_org.id).first
					VmiProgram.where(id: cust_rel.vmi_programs.collect(&:id)).update_all(customer_relationship_id: merge_into.id)
					OrganizationItem.where(id: cust_rel.organization_items.collect(&:id)).update_all(customer_relationship_id: merge_into.id)
				end
			end
		end
		if _ids
			update_relation(most_updated_org, attrs, 'has_many', false, _ids)
		end
	end
	puts 'other relations updated'
	if most_updated_account_id.nil?
		account_to_create << most_updated_org.id
	elsif least_updated_account_id.present?
		['alt_supplier_relationships', 'alt_customer_relationships'].each do |attrs|
			_ids = detailed_data[least_updated_org.id.to_s][attrs.to_sym]
			attrs = attrs.split('_')[1..-1].join('_')
			relation = attrs.singularize.camelcase.constantize
			if attrs == 'customer_relationships' || attrs == 'supplier_relationships'
				organization_ids = relation.where(id: _ids).collect(&:organization_id)
				organization_relations = relation.where(organization_id: organization_ids, account_id: most_updated_account_id).collect(&:organization_id)
				_ids = relation.where('organization_id not in (?) and id in (?)', organization_relations, _ids).collect(&:id)
				if attrs == 'customer_relationships'
					relation.where(organization_id: organization_relations, account_id: most_updated_account_id).each do |cust_rel|
						merge_into = relation.where(account_id: most_updated_account_id, organization_id: cust_rel.organization_id).first
						VmiProgram.where(id: cust_rel.vmi_programs.collect(&:id)).update_all(customer_relationship_id: merge_into.id)
						OrganizationItem.where(id: cust_rel.organization_items.collect(&:id)).update_all(customer_relationship_id: merge_into.id)
					end
				end
			end
			if _ids
				update_relation(Account.find most_updated_account_id, attrs, 'has_many', false, _ids)
			end
		end
		# update_relation(Account.find most_updated_account_id, 'supplier_relationships', 'has_many', false, detailed_data[least_updated_org.id.to_s][:alt_supplier_relationships])
		# update_relation(Account.find most_updated_account_id, 'customer_relationships', 'has_many', false, detailed_data[least_updated_org.id.to_s][:alt_customer_relationships])
	end
	puts 'backward relations updated'
	most_updated_org.attributes.each do |attrs, value|
		if value.blank? and least_updated_org[attrs].present?
			most_updated_org[attrs] = least_updated_org[attrs]
		end
	end
	most_updated_org.save!
end