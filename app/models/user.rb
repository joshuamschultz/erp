require 'role_model'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
  :trackable, :validatable, :lockable, :timeoutable

  include RoleModel
  # Setup accessible (or protected) attributes for your model


  roles_attribute :roles_mask

  roles :superadmin, :manager, :quality, :operations, :clerical, :logistics, :vendor, :customer, :support, :president,
  :plant_manager, :sales_manager, :operations_manager, :quality_manager, :logistics_manager


  # has_one :organization
  belongs_to :organization
  accepts_nested_attributes_for :organization

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

  has_many :created_quality_actions, :class_name => "QualityAction", :foreign_key => "created_user_id"

  has_many :quality_actions_users, :dependent => :destroy
  has_many :quality_actions, :through => :quality_actions_users

  has_many :organization_users, :dependent => :destroy
  has_many :organizations, :through => :organization_users


  has_many :quotes
  validates_presence_of :email, :name

  before_create :process_before_create

  def process_before_create
    self.roles << self.organization.organization_type.type_value if self.organization && self.organization.organization_type
  end

  class << self
    def current_user=(user)
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end
  end


  def self.user_organizations_associations(user, params)
        if user

          organizations = params[:organizations] || []
          user.organization_users.where.not(:organization_id => organizations).destroy_all
          if organizations
              organizations.each do |organization_id|
                unless user.organization_users.find_by_organization_id(organization_id)
                    user.organization_users.new(:organization_id => organization_id).save
                end
              end
          end
        end
  end
  def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :organization_attributes,
  :name, :gender, :address, :city, :state, :country, :telephone_no, :mobile_no, :active, :roles_mask, :organization_id, :time_zone)
  end

end
