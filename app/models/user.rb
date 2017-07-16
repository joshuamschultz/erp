# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  encrypted_password     :string(255)      not null
#  name                   :string(255)      not null
#  gender                 :string(255)
#  address                :text(65535)
#  city                   :string(255)
#  state                  :string(255)
#  country                :string(255)
#  telephone_no           :string(255)
#  mobile_no              :string(255)
#  fax                    :string(255)
#  active                 :boolean          default(TRUE)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  roles_mask             :integer
#  created_at             :datetime
#  updated_at             :datetime
#  organization_id        :integer
#  time_zone              :string(255)      default("Eastern Time (US & Canada)")
#

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

  validates :email, email_format: { message: "doesn't look like an email address" }
  #validates_length_of :name, :within => 4..100, :too_long => "pick a shorter name", :too_short => "pick a longer name"
  #validates_length_of :city, :within => 0..50, :too_long => "pick a shorter city"
  #validates_length_of :address, :within => 0..500, :too_long => "pick a shorter address"
  #validates_length_of :state,:within => 0..50, :too_long => "pick a shorter state"

  #validates :telephone_no, :mobile_no,   format: { with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/, message: "Invalid phone" }
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
