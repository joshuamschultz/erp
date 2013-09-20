class SoHeader < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
	attr_accessible :so_bill_to_id, :so_cofc, :so_comments, :so_identifier, :so_notes, 
	:so_ship_to_id, :so_squality, :so_status, :so_total, :organization_id
  
  validates_presence_of :organization
  
  belongs_to :organization

  belongs_to :bill_to_address, :class_name => "Contact", :foreign_key => "so_bill_to_id", 
	:conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

  belongs_to :ship_to_address, :class_name => "Contact", :foreign_key => "so_ship_to_id", 
	:conditions => ['contactable_type = ? and contact_type = ?', 'Organization', 'address']

	has_many :attachments, :as => :attachable, :dependent => :destroy  
	has_many :comments, :as => :commentable, :dependent => :destroy
	has_many :so_lines, :dependent => :destroy
  has_many :receivables, :dependent => :destroy

	before_create :before_create_level_defaults

  def before_create_level_defaults
  		self.so_status = "open"
    	self.so_identifier = Time.now.strftime("%m%y") + ("%03d" % (SoHeader.where("month(created_at) = ?", Date.today.month).count + 1))
    	self.so_identifier.slice!(2)
      self.so_identifier = "S" + self.so_identifier
  end

  def redirect_path
      so_header_path(self)
  end

  scope :status_based_sos, lambda{|status| where(:so_status => status) }
  
end
