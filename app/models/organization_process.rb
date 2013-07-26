class OrganizationProcess < ActiveRecord::Base
  belongs_to :organization
  belongs_to :process_type

  belongs_to :created_by, :class_name => "User", :foreign_key => "org_process_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "org_process_updated_id"

  attr_accessible :org_process_active, :org_process_created_id, :org_process_updated_id, :organization_id, :process_type_id

  def self.process_organization_processes(current_user, organization, processes)
  		organization.organization_processes.where(:process_type_id != processes).destroy_all

  		if processes
	      	processes.each do |process_id|
				unless organization.organization_processes.find_by_process_type_id(process_id)
					process = organization.organization_processes.new(:process_type_id => process_id)
					process = CommonActions.record_ownership(process, current_user) 
					process.save
				end
	      	end
	    end
  end

  after_initialize :default_values

  def default_values
		self.org_process_active ||= true
  end


end
