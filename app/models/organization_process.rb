# == Schema Information
#
# Table name: organization_processes
#
#  id                     :integer          not null, primary key
#  organization_id        :integer
#  process_type_id        :integer
#  org_process_active     :boolean
#  org_process_created_id :integer
#  org_process_updated_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class OrganizationProcess < ActiveRecord::Base
  after_initialize :default_values

  def default_values
    self.org_process_active = true if self.org_process_active.nil?
  end

  belongs_to :organization
  belongs_to :process_type
  belongs_to :created_by, :class_name => "User", :foreign_key => "org_process_created_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "org_process_updated_id"

  def self.process_organization_processes(current_user, organization, processes)
    organization.organization_processes.where.not(:process_type_id => processes).destroy_all
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

end
