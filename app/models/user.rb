require 'role_model'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
  :trackable, :validatable, :token_authenticatable, :lockable, :timeoutable

  include RoleModel
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
  :name, :gender, :address, :city, :state, :country, :telephone_no, :mobile_no, :active, :roles_mask
  # attr_accessible :title, :body

  roles_attribute :roles_mask

  roles :superadmin, :manager, :quality, :operations, :clerical, :logistics, :vendor, :customer

  has_one :organization 

  has_many :inspected_lots, :class_name => "QualityLot", :foreign_key => "lot_inspector_id"

  has_many :created_materials, :class_name => "Material", :foreign_key => "material_created_id"
  has_many :updated_materials, :class_name => "Material", :foreign_key => "material_updated_id"

  has_many :created_elements, :class_name => "MaterialElement", :foreign_key => "element_created_id"
  has_many :updated_elements, :class_name => "MaterialElement", :foreign_key => "element_updated_id"

  has_many :created_comments, :class_name => "Comment", :foreign_key => "comment_created_id"
  has_many :updated_comments, :class_name => "Comment", :foreign_key => "comment_updated_id"

  has_many :created_org_processes, :class_name => "OrganizationProcess", :foreign_key => "org_process_created_id"
  has_many :updated_org_processes, :class_name => "OrganizationProcess", :foreign_key => "org_process_updated_id"

  has_many :created_attachments, :class_name => "Attachment", :foreign_key => "attachment_created_id"
  has_many :updated_attachments, :class_name => "Attachment", :foreign_key => "attachment_updated_id"
end
