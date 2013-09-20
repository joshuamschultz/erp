class PoHeader < ActiveRecord::Base 
  include Rails.application.routes.url_helpers

  attr_accessible :po_active, :po_created_id, :po_description, :po_identifier, :po_notes, 
  :po_status, :po_total, :po_type_id, :po_updated_id, :organization_id

  validates_presence_of :organization
  validates_presence_of :po_type

  # (validates_uniqueness_of :po_identifier if validates_length_of :po_identifier, :minimum => 2, :maximum => 50) if validates_presence_of :po_identifier

  before_create :before_create_level_defaults

  def before_create_level_defaults
		self.po_status = "open"
    self.po_identifier = Time.now.strftime("%m%y") + ("%03d" % (PoHeader.where("month(created_at) = ?", Date.today.month).count + 1))
    self.po_identifier.slice!(2)
    self.po_identifier = "P" + self.po_identifier
  end

  belongs_to :organization, :conditions => ['organization_type_id = ?', MasterType.find_by_type_value("vendor").id]

  belongs_to :po_type, :class_name => "MasterType", :foreign_key => "po_type_id", 
  	:conditions => ['type_category = ?', 'po_type']

  has_many :po_lines, :dependent => :destroy
  has_many :quality_lots, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :attachments, :as => :attachable, :dependent => :destroy
  has_many :payables, :dependent => :destroy

  def redirect_path
    po_header_path(self)
  end

  scope :status_based_pos, lambda{|status| where(:po_status => status) }

end
